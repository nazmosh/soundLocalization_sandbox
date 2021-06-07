import os
import numpy as np
import librosa
import tensorflow as tf
from sklearn.model_selection import train_test_split
from model import EnvNet
from train import train_model
from data_preprocess import make_frames,make_frames_folder
models = {}
folders = os.listdir('./UrbanSound8K/audio')
frame_length = 5
overlapping_fraction = 0.2
dataset = make_frames_folder(folders,frame_length,overlapping_fraction)

