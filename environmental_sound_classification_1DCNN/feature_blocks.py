import torch
import torch.nn as nn
from gammatone_init import GammatoneInit

class FeatureBlock1(nn.Module):
    def __init__(self):
        super(FeatureBlock1, self).__init__()
        self.l1 = nn.Conv1d(in_channels=16, out_channels=16, kernel_size=64, stride=2)
        self.l2 = nn.ReLU()
    
    def forward(self,inputs):
        x = self.l1(inputs)
        x = self.l2(x)
        return x
            