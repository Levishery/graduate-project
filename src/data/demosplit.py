import os

from data import common

import numpy as np
import imageio

import torch
import torch.utils.data as data

class DemoSplit(data.Dataset):
    def __init__(self, args, name='Demo', train=False, benchmark=False):
        self.args = args
        self.name = name
        self.scale = args.scale
        self.idx_scale = 0
        self.train = False
        self.benchmark = benchmark

        self.filelist = []
        for f in os.listdir(args.dir_demo):
            if f.find('.png') >= 0 or f.find('.jp') >= 0:
                self.filelist.append(os.path.join(args.dir_demo, f))
        self.filelist.sort()

    def __getitem__(self, idx):
        filename = os.path.splitext(os.path.basename(self.filelist[idx]))[0]
        lr = imageio.imread(self.filelist[idx])
        lr, = common.set_channel(lr, n_channels=self.args.n_colors)
        lr, patch_shape = self.split(lr, self.args.patch_size//self.args.scale[0])
        np_transpose = np.ascontiguousarray(lr.transpose((3, 2, 0, 1)))
        lr_t = torch.from_numpy(np_transpose).float()
        lr_t.mul_(self.args.rgb_range / 255)

        return lr_t, patch_shape, filename

    def __len__(self):
        return len(self.filelist)

    def set_scale(self, idx_scale):
        self.idx_scale = idx_scale

    def split(self, lr, patch_size):
        patch_w = lr.shape[0]//patch_size
        patch_h = lr.shape[1]//patch_size
        result = np.zeros((patch_size, patch_size, self.args.n_colors, patch_w*patch_h))
        num = 0
        for i in range(patch_w):
            for j in range(patch_h):
                result[:, :, :, num] = lr[i*patch_size:(i+1)*patch_size, j*patch_size:(j+1)*patch_size, :]
                num = num+1
        return result, (patch_w, patch_h)




