function [im3d_dist] = distance3d(x,y,z,s1,s2)
    persistent storage;
    if isempty(storage)
        storage = cell(1,s1*s2*128);
    end
    if size(storage{(x-1)*s2+(y-1)*128+z},1)~=0
           im3d_dist = storage{(x-1)*s2+(y-1)*128+z};
           return
    end
    im3d_dist = double(zeros(s1,s2,128));

    c = 0.005;

    for i=1:s1
        for j=1:s2
            for k=1:128
                im3d_dist(i,j,k) = sqrt((i-x)^2 + (j-y)^2 + c*(k^2+z^2));
            end
        end
    end
    
    storage{(x-1)*s2+(y-1)*128+z} = im3d_dist;

end

