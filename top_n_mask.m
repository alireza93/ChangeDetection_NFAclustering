function [mask] = top_n_mask(maxClusters,pointVec,imgSize,n)
%top_n_mask Creates a binary mask from the top n clusters present in the
%input cell array
%   inputs:
%   maxClusters a cell array of clusters. each cluster is an array of
%   indices
%   pointVec a m*2 matrix of 2d indices
%   imgSize size of the image the indices belong to
%   n number of top clusters to be used
%   outputs:
%   mask binary mask of the top n clusters
mask = zeros(imgSize);
no = min(n,size(maxClusters,1));
for i=1:no
    cluster = maxClusters{i};
    whites = pointVec(cluster,:);
    mask(sub2ind(imgSize,whites(:,1),whites(:,2))) = i;
end

end

