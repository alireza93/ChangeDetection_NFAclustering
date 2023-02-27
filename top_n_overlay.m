function [] = top_n_overlay(img,maxClusters,pointVec,sz,n, parentAxes)
%top_n_overlay Visualises top n clusters present in the test image overlayed on
%top of it
%   inputs:
%   img the test image
%   maxClusters a cell array of clusters. each cluster is an array of
%   indices
%   pointVec a m*2 matrix of 2d indices
%   sz size of the image the indices belong to (can be smaller than the size of the test image).
%   n number of top clusters to be visualised
%   parentAxes the parent axes for the 3D plot. By default gcf.

if nargin<6
    parentAxes = gcf;
end
clrmap = [1,0,0;0,1,0;0,0,1;1,1,0;1,0,1;0,1,1;1,1,0.5;0.5,1,1;1,0.5,1;0.5,0.5,0.5];

cx = size(img,1)/sz(1);
cy = size(img,2)/sz(2);

imshow(img,'parent',parentAxes);
hold(parentAxes,'on');
axis(parentAxes,'off');

for i=1:n
    cluster = maxClusters{i};
    whites = pointVec(cluster,:);
    %y = min(whites(:,1));
    %x = min(whites(:,2));
    %width = max(whites(:,2)) - x;
    %height = max(whites(:,1)) - y;
    % rectangle('Position',[x,y,width,height], 'LineWidth',2,'EdgeColor','r');
    
    
    j = boundary(whites(:,1),whites(:,2),0.8);
    hold(parentAxes,'on');
    plot(parentAxes,floor(whites(j,2)*cy),floor(whites(j,1)*cx),'LineWidth',2,'color',clrmap(i,:)); 
    %text(parentAxis,x-2,y+floor(height/2)+2,[' ',num2str(i),' '],'Color','red','FontSize',14);
end

end

