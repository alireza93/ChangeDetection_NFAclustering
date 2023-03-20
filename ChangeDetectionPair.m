function [maxClusters,pointVec] = ChangeDetectionPair(img_ref,img_test,ccf)
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
    if nargin < 2
        print("Not enough parameters!");
        return;
    elseif nargin == 2
        ccf = 0.01;
    elseif nargin > 3
        print("Too many parameters!");
        return;
    end

    img_dif = compare(img_ref,img_test);
    th = prctile(img_dif(:),97);
    img_dif = imresize(img_dif,[90 NaN]);
    [maxClusters,pointVec,debug] = NFAC_gl(img_dif,ccf,th);
end

