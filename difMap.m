function [difMap] = difMap(img1,img2, tx, ty, cdf)

    lab_t1 = rgb2lab(img1);
    lab_t2 = rgb2lab(img2);

    difMap = zeros(size(img1,1),size(img1,2));
    
    for i=1:size(img1,1)    
        for j=1:size(img1,2)
            if (i+tx)>size(img1,1) || (i+tx)<1 || (j+ty)>size(img1,2) || (j+ty)<1
                dif = 0;
            else
                switch cdf
                    case 2
                        dif = calcCIEDE2k(permute(lab_t1(i,j,:),[1,3,2]),permute(lab_t2(i+tx,j+ty,:),[1,3,2]));
                    case 1
                        dif = calcCIE94(permute(lab_t1(i,j,:),[1,3,2]),permute(lab_t2(i+tx,j+ty,:),[1,3,2]));
                    case 0
                        dif = calcCIELab(permute(lab_t1(i,j,:),[1,3,2]),permute(lab_t2(i+tx,j+ty,:),[1,3,2]));
            
                end
            end
            difMap(i,j) = dif;
        end
    end

end

