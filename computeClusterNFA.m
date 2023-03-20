function [logNFA, debug] = computeClusterNFA(imgBk, k, minDist, minPrim, M)
     if (k>(M*0.35))
         logNFA = 0;
         debug = [];       
         return;
     end
    
    s1 = size(imgBk,1);
    s2 = size(imgBk,2);

    [xs,ys,zs]=find(imgBk);
    
    try
        [chull,chullArea] = convhull(xs,ys);
    catch
        chullArea = size(xs,1);
    end
    
    chullArea=chullArea/(s1*s2);
    
    if chullArea>0.5
       logNFA = 0;
       debug = [];
       return;
    end

    rad = minDist;
    im3d = uint8(zeros(s1,s2,128));

    maxgr = -inf;
    for i=1:s1
        for j=1:s2
            if imgBk(i,j)~=0
                im3d(i,j,imgBk(i,j)) = 255;
                if imgBk(i,j)>maxgr
                    maxgr=imgBk(i,j);
                end
            end
        end
    end

    imdil = dilate3d(im3d,rad);
    
    rad = (abs(minPrim));
    imdil2 = dilate3d(im3d,rad);
    imbound = imdil2 & ~imdil;
   
    vol1 = sum(imdil~=0,'all')/(s1*s2*128);   
    vol2 = sum(imbound~=0,'all')/(s1*s2*128);

    logNFA = ClusterNFA(M,k,vol1,vol2);

    debug(1) = logNFA;
    debug(2) = vol1;
    debug(3) = vol2;
    debug(4) = minDist;
    debug(5) = minPrim;    
    debug(6) = k;
       
end

