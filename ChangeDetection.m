function [maxClusters,pointVec,img_dif] = ChangeDetection(img_ref,img_test,ccf)
%ChangeDetection Computes the meaningful clusters of points present in the difference image between two colour images using the a-contrario framework 
%   inputs:
%   img_ref reference image
%   img_test test image
%   ccf parameter which gives importance to the difference value as opposed
%   to spatial closeness
%   outputs:
%   maxClusters a cell array of clusters ordered based on their
%   meaningfulness
%   pointVec coordinates of all the points in the 3d point cloud
%   img_dif the difference map betweem img_ref and img_test 
    if nargin < 2
        print("Not enough parameters!");
        return;
    elseif nargin == 2
        ccf = 0.01;
    elseif nargin > 3
        print("Too many parameters!");
        return;
    end

    MAX_PIXEL_COUNT = 10000;
    img_dif = compare(img_ref,img_test);
    th = prctile(img_dif(:),97);
    scale = sqrt(MAX_PIXEL_COUNT/(size(img_dif,1)*size(img_dif,2)));
    img_dif = imresize(img_dif,scale);
    [maxClusters,pointVec,debug] = NFAC_gl(img_dif,ccf,th);
    
end

