function [maxClusters,pointVec] = ChangeDetectionSeries(bw)
%ChangeDetectionSeries Computes the 3D clusters present in a series of binary
%images
%   inputs: 
%   bw a cell array of binary images of the same size
%   outputs:
%   maxClusters a cell array of clusters ordered based on their
%   meaningfulness
%   pointVec coordinates of all the points in the 3d point cloud

thirdDimFact = 2;  
pointVec = [];
datasetSize = size(bw,2);
for i=1:datasetSize
    bw{i} = imresize(bw{i},[90 NaN]);
    [rows,cols] = find(bw{i});
    pointVec = [pointVec; [rows,cols,repelem((i-1)*thirdDimFact,size(rows,1))']];
end

maxClusters = NFAC_time(pointVec,[size(bw{1}),thirdDimFact*datasetSize]);

end

