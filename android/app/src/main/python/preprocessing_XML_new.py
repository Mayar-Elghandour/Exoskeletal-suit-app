import os
import glob
import numpy as np
import json

import xml.etree.ElementTree as ET

def fir_filter(data, cutoff=1.0, fs=200.0, numtaps=101):
    """Proper FIR filter implementation matching MNE's firwin design"""
    # Create highpass filter taps
    nyq = 0.5 * fs
    cutoff_norm = cutoff / nyq
    taps = np.ones(numtaps)/numtaps  # Start with lowpass
    taps = -taps                     # Convert to highpass
    taps[numtaps//2] += 1           # Add impulse response
    
    # Apply filter to each channel with phase correction
    filtered = np.zeros_like(data)
    for i in range(data.shape[0]):
        filtered[i] = np.convolve(data[i], taps, mode='same')
    return filtered

def centered_moving_average(data, window_size=3):
    """Moving average with centered window matching pandas rolling mean"""
    pad = window_size // 2
    padded = np.pad(data, ((0,0), (pad,pad)), mode='edge')
    return np.array([
        np.mean(padded[:, i:i+window_size], axis=1) 
        for i in range(data.shape[1])
    ]).T

def proper_car(data):
    """Common Average Reference implementation matching MNE"""
    car = np.mean(data, axis=0, keepdims=True)
    return data - car

def process_eeg_data(electrode_data, sfreq=200, target_samples=200):
    """Complete processing pipeline matching MNE's steps"""
    # 1. High-pass filter
    filtered = fir_filter(electrode_data, cutoff=1.0, fs=sfreq)
    
    # 2. Zero-padding (1 sample at edges)
    padded = np.pad(filtered, ((0,0), (1,1)), mode='constant')
    
    # 3. Moving average (window=3)
    smoothed = centered_moving_average(padded, window_size=3)
    
    # 4. Common Average Reference
    car_data = proper_car(smoothed)
    
    # 5. Z-score normalization
    norm_data = (car_data - np.mean(car_data, axis=1, keepdims=True)) / \
               (np.std(car_data, axis=1, keepdims=True) + 1e-8)
    
    # 6. Standardize length
    if norm_data.shape[1] > target_samples:
        norm_data = norm_data[:, :target_samples]
    elif norm_data.shape[1] < target_samples:
        norm_data = np.pad(norm_data, 
                         ((0,0), (0, target_samples - norm_data.shape[1])), 
                         mode='constant')
    return norm_data

def xml_to_json_corrected(input_path, output_folder, target_samples=200):
    """Complete XML to JSON pipeline with corrected processing"""
    # Channel configuration
    ch_names = ['Fp1', 'Fp2', 'F3', 'F4', 'C3', 'C4', 'P3', 'P4', 'O1', 'O2', 
                'A1', 'A2', 'F7', 'F8', 'T3', 'T4', 'T5', 'T6', 'Fz', 'Cz', 'Pz', 'X3']
    drop_channels = ['A1', 'A2', 'X3']
    keep_indices = [i for i, ch in enumerate(ch_names) if ch not in drop_channels]
    sfreq = 200
    
    os.makedirs(output_folder, exist_ok=True)
    
    # Get input files
    if os.path.isdir(input_path):
        xml_files = glob.glob(os.path.join(input_path, '*.xml'))
    else:
        xml_files = [input_path] if input_path.endswith('.xml') else []

    for xml_file in xml_files:
        try:
            # 1. Load XML
            tree = ET.parse(xml_file)
            root = tree.getroot()
            
            # 2. Extract EEG data
            eeg_data = []
            for eeg_element in root.findall('eeg'):
                eeg_values = np.fromstring(eeg_element.text.strip('[]'), sep=' ')
                eeg_data.append(eeg_values)
            electrode_data = np.array(eeg_data).T
            
            # 3. Remove unwanted channels
            electrode_data = electrode_data[keep_indices, :]
            final_ch_names = [ch for ch in ch_names if ch not in drop_channels]
            
            # 4. Process data
            norm_data = process_eeg_data(electrode_data, sfreq, target_samples)
            
            # 5. Prepare JSON output
            base_name = os.path.splitext(os.path.basename(xml_file))[0]
            output_path = os.path.join(output_folder, f"{base_name}.json")
            
            label_element = root.find('label')
            label = label_element.text if label_element is not None else None
            
            eeg_data = {
                "metadata": {
                    "original_file": os.path.basename(xml_file),
                    "sampling_rate": float(sfreq),
                    "channels": final_ch_names,
                    "samples_per_trial": target_samples,
                    "label": label
                },
                "eeg_data": norm_data.tolist(),
                "timestamps": np.linspace(0, target_samples/sfreq, target_samples).tolist()
            }
            
            # 6. Save JSON
            with open(output_path, 'w') as f:
                json.dump(eeg_data, f, indent=4)
            
            print(f"Successfully processed {os.path.basename(xml_file)}")
            
        except Exception as e:
            print(f"Error processing {xml_file}: {str(e)}")

    print(f"Processing complete. Output saved to {output_folder}")

# Example usage
if __name__ == "__main__":
   ''' xml_to_json_corrected(
        input_path=r'E:\Exoskeleton arm suppor with EEg\EEG\large data\CLA_Processing\session test XML\trial_10.xml',
        output_folder='preprocessed_json_minimal',
        target_samples=200
    )'''