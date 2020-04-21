clc;
clear;
h = 620*3;
w = 920*3;
num = 100;
width = 13;
len = 45;
begin_h = 5;
begin_w = 5;
end_w = 5;
img_path = '/home/citrine/saphire/datasets/IAM_test/forms_3600/';
target_path = '/home/citrine/saphire/datasets/IAM_test/forms_1200_mixed/';
light_path = '/home/citrine/saphire/datasets/IAM/light/';
lights = dir(light_path);
num_light = length(lights)-2;
imgs = dir(img_path);
m = length(imgs)-2;

for i=1:m
    imgname = imgs(i+2).name;
    sub_path = [img_path , imgname];
    targetsub_path = [target_path, imgname];
    im = imread(sub_path);
    % add blank
    for k = 1:num
        loc = [begin_w+ceil((w-begin_w-end_w)*rand()), begin_h+ceil((h-len-2*begin_h)*rand)];
        blank = [im(loc(1),loc(2)),im(loc(1)+1,loc(2)),im(loc(1),loc(2)+1),im(loc(1)-1,loc(2)), im(loc(1),loc(2)-1)];
        blank = max(blank);
        if(blank<180)
            continue
        end
        for j = 1:len
            im(loc(1):loc(1)+4, loc(2)+j-1) = blank;
        end
    end
    for k = 1:num
        loc = [begin_w+ceil((w-len-begin_w-end_w)*rand()), begin_h+ceil((h-2*begin_h)*rand)];
        blank = [im(loc(1),loc(2)),im(loc(1)+1,loc(2)),im(loc(1),loc(2)+1),im(loc(1)-1,loc(2)), im(loc(1),loc(2)-1)];
        blank = max(blank);
        if(blank<180)
            continue
        end
        for j = 1:len
            im(loc(1)+j-1, loc(2):loc(2)+4) = blank;
        end
    end
    % add light
    light = [light_path lights(ceil(8*rand())+2).name];
    lightim = imread(light);
    lightim = imresize(lightim, [w, h], 'bicubic');
    im = im-0.3*rand()*lightim;
    % blur kernel
    if(rand() > 0.5)
        r=7*rand(); %散焦半径r
        PSF=fspecial('disk',r);   %得到点扩散函数
        im = imfilter(im,PSF,'symmetric','conv');
    else
        PSF = fspecial('motion',15*rand(),360*rand());
        im = imfilter(im,PSF,'conv','circular');
    end
    
    im = imresize(im, [w/3, h/3], 'bicubic');
    % add noise
    im = imnoise(im, 'gaussian', 0, 5^2/255^2);
    std = 5;
    im = imnoise(im, 'salt & pepper', std^2/255^2);
    imwrite(im, targetsub_path);
end
