function [logNFA, debug] = computeClusterNFAv6(imgBk, k, minDist, minPrim, M)
 %    k = 2*k;
  %   M = M + k;
% figure, imshow(imgBk);
   if k==52
        asd = 0;
    end
     if (k>(M*0.35))
         logNFA = 0;
         debug = [];
         
         return;
     end
    
   %  imshow(imgBk,[]);
    s1 = size(imgBk,1);
    s2 = size(imgBk,2);
    

    [xs,ys,zs]=find(imgBk);
    
    try
        [chull,chullArea] = convhull(xs,ys);
    catch
        chullArea = size(xs,1);
    end
    
    chullArea=chullArea/(s1*s2);%      end
    
    if chullArea>0.5
       logNFA = 0;
       debug = [];
       return;
    end




    
%     if(k>s1*s2*0.4)
%         logNFA = 0;
%         debug = [];
%         return;
%     end
    
    rad = minDist;
    
    im3d = uint8(zeros(s1,s2,128));
    
 %   if size(pt,2)~=1
   %     imdil = dilate3d(im3d,rad,pt);
  %  else
    
        maxgr = -inf;
        for i=1:s1
            for j=1:s2
                if imgBk(i,j)~=0
                    im3d(i,j,imgBk(i,j)) = 255;
                    if imgBk(i,j)>maxgr
                        maxgr=imgBk(i,j);
                    end
                    %im3d(i,j,1) = 255;
                    %pcl(pcli,:)=[i,j,imgBk(i,j)];
                    %pcli = pcli + 1;
                end
            end
        end
        
        imdil = dilate3d(im3d,rad);
    
 %   end
    
%     if isempty(imdil)
%         logNFA = 0;
%         debug = [];
%         1;
%         return;
%     end
    
    rad = (abs(minPrim));
    imdil2 = dilate3d(im3d,rad);
    imbound = imdil2 & ~imdil;
    %if k>100
    %    k
    %end
    
    vol1 = sum(imdil~=0,'all')/(s1*s2*128);   
    vol2 = sum(imbound~=0,'all')/(s1*s2*128);
    
    
    %logNFA = M*((k/M)*log10((k/M)/vol1) + (1-(k/M))*log10((1-(k/M))/(1-vol2-vol1)));

    %mex ClusterNFA.cpp -ID:\boost_1_72_0
    
    
 %   chullVol=chullVol/(s1*s2*128);
    
  %  if vol1==0, vol1=chullVol; end
    
   
        logNFA = ClusterNFA(M,k,vol1,vol2);
    
    
    
    %if(k>10)
        %volshow(im3d);
   %     imshow(im2d);
  %      imwrite(im2d,['out/1/',int2str(k),'.png']);
        debug(1) = logNFA;
        debug(2) = vol1;
        debug(3) = vol2;
        debug(4) = minDist;%chullArea;
        debug(5) = minPrim;
        
        debug(6) = k;
        
    %end
    
    
    
    
end

