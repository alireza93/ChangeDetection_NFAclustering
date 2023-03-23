function [maxClusters,pointVec] = ChangeDetectionSeries(imgs)
%ChangeDetectionSeries Computes the 3D clusters of changed points present
%in a series of images
%images
%   inputs: 
%   imgs a cell array of images of the same size
%   outputs:
%   maxClusters a cell array of clusters ordered based on their
%   meaningfulness
%   pointVec coordinates of all the possible changed points in the 3d point cloud

ccf = 0.1;
n = 4;
datasetSize = size(imgs,2);
img_ref = imgs{1};
for i=2:datasetSize
    i-1
    img_test = imgs{i};
    [maxClusters,pointVec,img_dif] = ChangeDetection(img_ref,img_test,ccf);
    bw{i-1} = top_n_mask(maxClusters,pointVec,size(img_dif),n);
end

[maxClusters,pointVec] = find3Dclusters(bw);

end

