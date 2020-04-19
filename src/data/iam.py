import os
from data import srdata
import glob

class IAM(srdata.SRData):
    def __init__(self, args, name='IAM', train=True, benchmark=False):
        super(IAM, self).__init__(
            args, name=name, train=train, benchmark=benchmark
        )

    def _scan(self):
        names_hr = sorted(
            glob.glob(os.path.join(self.dir_hr, '*' + '.png'))
        )
        names_lr = sorted(
            glob.glob(os.path.join(self.dir_lr, '*' + '.png'))
        )
        names_lr = [names_lr]
        return names_hr, names_lr

    def _set_filesystem(self, dir_data):
        if(self.train):
            self.apath = os.path.join(dir_data, self.name)
        else:
            self.apath = os.path.join(dir_data, self.name + '_test')
        self.dir_hr = os.path.join(self.apath, 'forms_3600')
        self.dir_lr = os.path.join(self.apath, 'forms_1200_'+self.args.datatype)
        self.ext = ('.png', '.png')
