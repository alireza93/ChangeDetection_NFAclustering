function [im3d_dil] = dilate3d(im3d,r,point)
   % persistent im3d_dil_prev;
    
    if r==0
        im3d_dil = im3d;
        return;
    end
    
    [s1,s2,s3] = size(im3d);
    
%     if size(point,2)~=1 %a matrix
%         im3d_dist = distance3d(point(1),point(2),point(3),s1,s2);
%         im3d_dist(im3d_dist>r) = 0;
%         im3d_dil = im3d_dil_prev | logical(im3d_dist);
%         return;
%     end
%     
    
    
    %im3d_dil = Inf([s1,s2,s3],'distributed');
    
    pt = find(im3d);
    
    if size(pt,1)==0
        im3d_dil = im3d;
        return;
    end
    for l=1:size(pt,1)
        [i,j,k] = ind2sub([s1,s2,s3],pt(l));
        im3d_dist = distance3d(i,j,k,s1,s2);
        %if(im3d_dist(1,1,end)<r) %performance limit
        %    im3d_dil = ones(size(im3d_dist));
        %    return;
        %end
        %im3d_dist(im3d_dist>r) = 0;

%                     if nnz(im3d_dist)==0
%                         fprintf("(%f,%f)\n",k,r);
%                         im3d_dil = [];
%                         return;
%                     end
        if l==1
            im3d_dil = im3d_dist;
        else
            try
                im3d_dil = min(im3d_dist,im3d_dil);
            catch
                i
            end
        end
        %figure, volshow(im3d_dist);
        %figure, volshow(im3d_dil);
    end
    
    im3d_dil(im3d_dil>r) = 0;
    im3d_dil = logical(im3d_dil);

%     if point~=1 %do not store
%         im3d_dil_prev = im3d_dil;
%     end
end

