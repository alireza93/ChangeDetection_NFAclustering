function [] = visualisePointCloud(pointVec,img, parentAxes)
%visualisePointCloud Visualises a vector of points belonging to a difference image as a 3d point cloud
%   inputs:
%   pointVec a m*2 matrix of 2d indices
%   img a difference image
%   parentAxes the parent axes for the 3D plot. By default gcf.
if nargin<3
    parentAxes = gcf;
end

y = pointVec(:,1);
x = pointVec(:,2);
z = img(sub2ind(size(img),y,x));

scatter3(parentAxes,x,y,z,10,[0.1 0.1 0.2],'filled');

xlim(parentAxes,[0 size(img,2)]);
ylim(parentAxes,[0 size(img,1)]);
zlim(parentAxes,[0 max(z)]);

xlabel(parentAxes,'x');
ylabel(parentAxes,'y');
zlabel(parentAxes,'difference value');
end

