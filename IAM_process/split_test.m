clc;
clear;
img_path = '/home/citrine/saphire/datasets/IAM/forms_3600/';
target_path = '/home/citrine/saphire/datasets/IAM/test_3600/';
imgs = dir(img_path);
m = (length(imgs)-2)/20;
start = 800;
for i = start:start + m
    imgname = imgs(i+2).name;
    sub_path = [img_path , imgname];
    targetsub_path = [target_path, imgname];
    movefile(sub_path,target_path);
end