import cv2
import os
import random
im_path = '/home/citrine/saphire/datasets/IAM/forms_1200_erode/'
target_path = '/home/citrine/saphire/datasets/IAM/forms_1200_erode/'

list_im = os.listdir(im_path)
for name in list_im:
    print(name)
    img = cv2.imread(os.path.join(im_path, name))
    target_im = os.path.join(target_path, name.replace('.png', '.jpg'))
    cv2.imwrite(target_im, img,[int(cv2.IMWRITE_JPEG_QUALITY),40+55*random.random()])
    img = cv2.imread(target_im)
    cv2.imwrite(target_im.replace('.jpg','.png'), img)
    os.remove(target_im)

