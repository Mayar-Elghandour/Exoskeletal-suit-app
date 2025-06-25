import os
import glob
import numpy as np
import scipy.io as sio
import json
import mne
import pandas as pd

def mat_to_json_pipeline(input_path, output_folder, target_samples=200):
    """
    Complete EEG processing pipeline from .mat to JSON:
    1. Loads .mat file(s)
    2. Converts to MNE RawArray
    3. Applies preprocessing
    4. Saves as JSON
    
    Args:
        input_path (str): Path to .mat file or directory
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
        mat_files = glob.glob(os.path.join(input_path, '*.mat'))
    elif os.path.isfile(input_path) and input_path.endswith('.mat'):
        mat_files = [input_path]
    else:
        raise ValueError("Input must be a .mat file or directory containing .mat files")

    for mat_file in mat_files:
        # 1. Load .mat file
        mat_contents = sio.loadmat(mat_file)
        electrode_data = np.array(mat_contents['eeg'])
        
        # 2. Create MNE Raw object
        raw_info = mne.create_info(ch_names=ch_names, sfreq=200, ch_types=ch_types)
        raw = mne.io.RawArray(electrode_data.T, info=raw_info)
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
        base_name = os.path.splitext(os.path.basename(mat_file))[0]
        output_path = os.path.join(output_folder, f"{base_name}.json")
        
        eeg_data = {
            "metadata": {
                "original_file": os.path.basename(mat_file),
                "sampling_rate": 200.0,
                "channels": raw_car.ch_names,
                "samples_per_trial": target_samples
            },
            "eeg_data": norm_data.tolist(),
            "timestamps": np.linspace(0, target_samples/200, target_samples).tolist()
        }
        
        # 6. Save to JSON
        with open(output_path, 'w') as f:
            json.dump(eeg_data, f, indent=4)
        
        print(f"Processed {os.path.basename(mat_file)} -> {output_path}")

    print(f"\nProcessing complete! Saved {len(mat_files)} files to {output_folder}")
    print(f"Output path: {output_path}")
    return output_path

# Example usage:
mat_to_json_pipeline(
    input_path=r'assets\session test\session test\trial_13.mat',  # Input .mat file/folder
    output_folder=r'preprocessed_jsThis PC\realme 6\Internal shared storage\Download\preprocessed_mat\preprocessed_json',  # Output folder
)