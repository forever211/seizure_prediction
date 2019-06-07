
import os
import scipy.io as sio
import numpy as np
import matplotlib
from matplotlib import pyplot as plt
from matplotlib import rc
matplotlib.rcParams['text.usetex'] = True
matplotlib.rcParams['text.latex.unicode'] = True
plt.rcParams["font.family"] = "Bitstream Charter"

"""
This script plots a spectrogram of preictal and a spectrogram of interictal state.
"""

ident = '11502'
patient_id = '11502'

path_directory = '/net/store/ni/projects/Data/intracranial_data/Freiburg_epilepsy_unit/'
baseline_directory = 'patient_'+ident+'_extracted_seizures/data_baseline_'+patient_id+'/spectrograms_baseline'
preictal_directory = 'patient_'+ident+'_extracted_seizures/data_clinical_'+patient_id+'/spectrograms_preictal'

files_baseline = os.listdir(path_directory+baseline_directory)
files_preictal = os.listdir(path_directory+preictal_directory)

dict_spectrogram_baseline = sio.loadmat(path_directory+baseline_directory+'/'+files_baseline[32])
dict_spectrogram_preictal = sio.loadmat(path_directory+preictal_directory+'/'+files_preictal[4])

spectrogram_baseline = dict_spectrogram_baseline["spectrogram_baseline_1"]
spectrogram_preictal = dict_spectrogram_preictal["spectrogram_preictal"]

kill_IDX = list(np.linspace(195,205,11,dtype=int))
spectrogram_baseline = np.delete(spectrogram_baseline, kill_IDX, axis=2)
spectrogram_preictal = np.delete(spectrogram_preictal, kill_IDX, axis=2)

# plotting spectrograms
fig, ax = plt.subplots(1, 2, sharey=True, figsize=(16,8))
fig.subplots_adjust(left=0.08, bottom=0.12, right=0.92, top=0.92, wspace=0.16, hspace=0.22)

img1 = ax[0].imshow(np.rot90(spectrogram_preictal[0]), cmap='RdBu_r', aspect='auto', vmin=0.5, vmax=1.5, extent=[0,5,0,510])
ax[0].set_title('Preictal state', fontsize=26)
ax[0].set_xlabel('Time (min)', fontsize=26)
ax[0].set_xticklabels([-5,-4,-3,-2,-1,0], fontsize=22)
ax[0].set_ylabel('Frequency (Hz)', fontsize=26)
ax[0].set_yticks([0,125,250,375,500])
ax[0].set_yticklabels([0,32,64,96,128], fontsize=22)
ax[0].tick_params(axis="both", length=8)

img2 = ax[1].imshow(np.rot90(spectrogram_baseline[0]), cmap='RdBu_r', aspect='auto', vmin=0.5, vmax=1.5, extent=[0,5,0,510])
ax[1].set_title('Interictal state', fontsize=26)
ax[1].set_xlabel('Time (min)', fontsize=26)
ax[1].set_xticklabels([-5,-4,-3,-2,-1,0], fontsize=22)
ax[1].tick_params(axis="both", length=8)

colorbar = fig.colorbar(img2, ax=ax.ravel().tolist(), fraction=0.046, pad=0.04)
colorbar.ax.tick_params(length=8, labelsize=22)

fig.text(0.043, 0.12, r"$\textbf{A}$", fontsize=26)
fig.text(0.47, 0.12, r"$\textbf{B}$", fontsize=26)
fig.text(0.95, 0.5, 'Relative power', va='center', rotation='vertical',fontsize=26)

# plt.savefig("figures/spectrogram.pdf", pad_inches=0.4)
plt.show()