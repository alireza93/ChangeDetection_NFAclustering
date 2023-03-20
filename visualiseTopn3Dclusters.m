function [] = visualiseTopn3Dclusters(maxClusters,pointVec,n)
%visualiseTopn3Dclusters Visualises the top n 3D clusters present in an
%image series
%   inputs:
%   maxClusters a cell array of clusters. each cluster is an array of
%   indices
%   pointVec a m*3 matrix of 2d indices which are points present in the
%   image series point cloud.
%   n number of top cluster to visualised
%   
clrmap = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;1,1,0.5;0.5,1,1;1,0.5,1;0.5,0.5,0.5];
figure; hold on;
for i=1:size(maxClusters,1)
    cluster = maxClusters{i};
    whites = pointVec(cluster,:);
    
    y = whites(:,1);
    x = whites(:,2);
    z = whites(:,3);

    if i>n
        scatter3(x,y,z,10,[0.8 0.8 0.8],'filled');
    else
        scatter3(x,y,z,10,clrmap(rem(i-1,10)+1,:),'filled');
    end
end
view([37.5 30])
end

