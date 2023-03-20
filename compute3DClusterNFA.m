function [logNFA] = compute3DClusterNFA(im3d, k, minDist, minPrim, M) 

    [s1,s2,s3] = size(im3d);
    
    rad = ceil(minDist/2);
    se = strel('sphere',rad);
    
    imgDil1 = imdilate(im3d,se);
    
    
    
    rad = ceil(abs(minPrim-minDist));
    se = strel('sphere',rad);
    
    if(rad == 0)
        imgA1 = imgDil1;
        imgA15 = imgDil1;
    else    
        imgA1 = imdilate(imgDil1,se);
        imgA15 = imerode(imgA1,se);       
    end
    
    try   
       [pclx,pcly,pclz] = ind2sub(size(imgA15),find(imgA15));            
       [chull,volChull] = convhull(pclx,pcly,pclz);
       vol1 = volChull/(s1*s2*s3);
   catch ME
       vol1 = sum(imgA15~=0,'all')/(s1*s2*s3);
       logNFA = 0;
       return;
   end
    
    
    imgA2 = imgA1 - imgA15; 
    vol2 = sum(imgA2~=0,'all')/(s1*s2*s3);
   
    logNFA = ClusterNFA(M,k,vol1,vol2);
end

