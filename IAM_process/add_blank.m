clc;
clear;
h = 800;
w = 1200;
num = 100;
width = 3;
len = 15;
begin_h = 120;
begin_w = 60;
end_w = 220;
img_path = '/home/citrine/saphire/datasets/IAM_test/forms_3600/';
target_path = '/home/citrine/saphire/datasets/IAM_test/forms_1200_light/';
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
    im = imresize(im, [1200, 800], 'bicubic');
    % add blank
    for k = 1:num
        loc = [begin_w+ceil((w-begin_w-end_w)*rand()), begin_h+ceil((h-len-2*begin_h)*rand)];
        blank = [im(loc(1),loc(2)),im(loc(1)+1,loc(2)),im(loc(1),loc(2)+1),im(loc(1)-1,loc(2)), im(loc(1),loc(2)-1)];
        blank = max(blank);
        if(blank<180)
            continue
        end
        for j = 1:len
            im(loc(1), loc(2)+j-1) = blank;
            im(loc(1)+1, loc(2)+j-1) = blank;
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
            im(loc(1)+j-1, loc(2)) = blank;
            im(loc(1)+j-1, loc(2)+1) = blank;
        end
    end
    % add light
    light = [light_path lights(ceil(8*rand())+2).name];
    lightim = imread(light);
    im = im-0.3*rand()*lightim;
    % add noise
    im = imnoise(im, 'gaussian', 0, 5^2/255^2);
    imwrite(im, targetsub_path);
end
