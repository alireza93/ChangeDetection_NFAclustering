function [im3d_dil] = dilate3d(im3d,r)
    if r==0
        im3d_dil = im3d;
        return;
    end
    
    [s1,s2,s3] = size(im3d);
    
    pt = find(im3d);
    
    if size(pt,1)==0
        im3d_dil = im3d;
        return;
    end
    for l=1:size(pt,1)
        [i,j,k] = ind2sub([s1,s2,s3],pt(l));
        im3d_dist = distance3d(i,j,k,s1,s2);
        if l==1
            im3d_dil = im3d_dist;
        else
            try
                im3d_dil = min(im3d_dist,im3d_dil);
            catch
                i
            end
        end
        
    end
    
    im3d_dil(im3d_dil>r) = 0;
    im3d_dil = logical(im3d_dil);

end

