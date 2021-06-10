import torch.nn as nn
import torch.nn.functional as F
import torch.optim as optim
from feature_blocks import FeatureBlock1

class Net (nn.Module):
    def __init__ (self):
        super (Net, self).__init__()
        
    def forward (self, x):
        return x