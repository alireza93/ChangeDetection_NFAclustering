function [img_ref,img_test] = prep(img_ref,img_test)
%prep Summary of this function goes here
%   Detailed explanation goes here
%% simple intensity correction
b1 = mean2(rgb2gray(img_ref));
b2 = mean2(rgb2gray(img_test));

img_test = img_test - (b2-b1);

%% spatial registration
img_test = imgRegister(img_ref, img_test);
%% histogram equalisation
img_test = imhistmatch(img_test,img_ref,'method','uniform');

%% blurring
img_ref = imgaussfilt(img_ref,4);
img_test = imgaussfilt(img_test,4);

%% reflection removal
j1 = img_test(:,:,1);
j2 = img_test(:,:,2);
j3 = img_test(:,:,3);

i1 = img_ref(:,:,1);
i2 = img_ref(:,:,2);
i3 = img_ref(:,:,3);

idx1 = ((i3-i2)>15)|(((i3-i2)>5) & ((i1-i2)>5));
idx2 = ((j3-j2)>15)|(((j3-j2)>5) & ((j1-j2)>5));
%idx2 = (((j3-j2)>2) & ((j1-j2)>2));

for i=1:size(idx1,1)
    for j=1:size(idx1,2)
        if idx1(i,j) %|| idx2(i,j)
            img_test(i,j,:) = [0,0,0];
            img_ref(i,j,:) = [0,0,0];
        end
    end
end

end

