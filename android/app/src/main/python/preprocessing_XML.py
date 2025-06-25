import os
import glob
import numpy as np
import json
import mne
import pandas as pd
from xml.etree import ElementTree as ET

def xml_to_json_pipeline(input_path, output_folder, target_samples=200):
    """
    Complete EEG processing pipeline from XML to JSON:
    1. Loads XML file(s)
    2. Converts to MNE RawArray
    3. Applies preprocessing
    4. Saves as JSON
    
    Args:
        input_path (str): Path to XML file or directory
        output_folder (str): Where to save JSON files
        target_samples (int): Desired timepoints per trial (default: 200)
    """
    # Channel configuration
    ch_types = ['eeg'] * 22
    ch_names = ['Fp1', 'Fp2', 'F3', 'F4', 'C3', 'C4', 'P3', 'P4', 'O1', 'O2', 
                'A1', 'A2', 'F7', 'F8', 'T3', 'T4', 'T5', 'T6', 'Fz', 'Cz', 'Pz', 'X3']
    drop_channels = ['A1', 'A2', 'X3']
    
    # Create output folder
    os.makedirs(output_folder, exist_ok=True)
    
    # Get input files
    if os.path.isdir(input_path):
        xml_files = glob.glob(os.path.join(input_path, '*.xml'))
    elif os.path.isfile(input_path) and input_path.endswith('.xml'):
        xml_files = [input_path]
    else:
        raise ValueError("Input must be an XML file or directory containing XML files")

    for xml_file in xml_files:
        # 1. Load and parse XML file
        tree = ET.parse(xml_file)
        root = tree.getroot()
        
        # Extract EEG data from XML
        eeg_data = []
        for eeg_element in root.findall('eeg'):
            # Convert string of numbers to numpy array
            eeg_values = np.fromstring(eeg_element.text.strip('[]'), sep=' ')
            eeg_data.append(eeg_values)
        
        # Convert to numpy array (timepoints × channels)
        electrode_data = np.array(eeg_data).T  # Transpose to match MAT file format
        
        # 2. Create MNE Raw object
        raw_info = mne.create_info(ch_names=ch_names, sfreq=200, ch_types=ch_types)
        raw = mne.io.RawArray(electrode_data, info=raw_info)
        raw.drop_channels(drop_channels)
        
        # 3. Preprocessing pipeline
        # a) High-pass filter (1Hz cutoff)
        filtered = raw.filter(l_freq=1, h_freq=None, fir_design='firwin')
        
        # b) Zero-padding (1 sample at edges)
        data = filtered.get_data()
        padded_data = np.pad(data, ((0,0), (1,1)), mode='constant')
        
        # c) Moving average (window=3)
        window_size = 3
        smoothed_data = np.zeros_like(padded_data)
        for i in range(padded_data.shape[0]):
            smoothed_data[i] = pd.Series(padded_data[i]).rolling(
                window_size, min_periods=1).mean().values
        
        # d) Common Average Reference
        raw_car = mne.io.RawArray(smoothed_data, filtered.info)
        raw_car.set_eeg_reference('average', projection=True).apply_proj()
        
        # e) Z-score normalization
        data = raw_car.get_data()
        norm_data = (data - np.mean(data, axis=1, keepdims=True)) / (
                   np.std(data, axis=1, keepdims=True) + 1e-8)
        
        # 4. Standardize length
        if norm_data.shape[1] > target_samples:
            norm_data = norm_data[:, :target_samples]
        elif norm_data.shape[1] < target_samples:
            norm_data = np.pad(norm_data, 
                             ((0,0), (0, target_samples - norm_data.shape[1])), 
                             mode='constant')
        
        # 5. Prepare JSON structure
        base_name = os.path.splitext(os.path.basename(xml_file))[0]
        output_path = os.path.join(output_folder, f"{base_name}.json")
        
        # Extract label if present in XML
        label_element = root.find('label')
        label = label_element.text if label_element is not None else None
        
        eeg_data = {
            "metadata": {
                "original_file": os.path.basename(xml_file),
                "sampling_rate": 200.0,
                "channels": raw_car.ch_names,
                "samples_per_trial": target_samples,
                "label": label
            },
            "eeg_data": norm_data.tolist(),
            "timestamps": np.linspace(0, target_samples/200, target_samples).tolist()
        }
        
        # 6. Save to JSON
        with open(output_path, 'w') as f:
            json.dump(eeg_data, f, indent=4)
        
        print(f"Processed {os.path.basename(xml_file)} -> {output_path}")

    print(f"\nProcessing complete! Saved {len(xml_files)} files to {output_folder}")

# Example usage:
xml_to_json_pipeline(
    input_path=r'session test XML\trial_10.xml',  # Input XML file/folder
    output_folder='preprocessed_json',  # Output folder
)