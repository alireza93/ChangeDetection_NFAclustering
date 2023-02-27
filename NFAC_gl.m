function [maxClusters, pointVec, debugMat] = NFAC_gl(difImg,ccf,th)
    s1 = size(difImg,1);
    s2 = size(difImg,2);
    border = 1;

    % difImg = rescale(difImg);
    % 
    % 
    % 
    % difImg(1:border,:)=0;
    % difImg((s1-border):s1,:)=0;
    % difImg(:,(s2-border):s2)=0;
    % difImg(:,1:border)=0;
    %imwrite(difImg,['./Segmentations/alg/3/dif',num2str(sampleNo),'.png']);

    %% binary threshold 


    bw = ones(ceil(size(difImg)));


    %bwList{j} = getBinary(result{j});
    temp = difImg;

    temp(temp<=th) = 0;
    temp(temp>th) = 1;
    bw = bw & temp;

    figure,imshow(bw,[]);
    figure,imshow(difImg,[]);
    %% Recover seed points



    [rows,cols] = find(bw);
    pointVec = [rows,cols];

    % pointVec(pointVec(:,1)<=border,:) = [];
    % pointVec(pointVec(:,2)<=border+7,:) = [];
    % pointVec(pointVec(:,1)>=size(bw,1)-border,:) = [];
    % pointVec(pointVec(:,2)>=size(bw,2)-border-7,:) = [];

    %%
    %im3d_dist = distance3d(i,j,k,s1,s2);

    %% function
    %d=linspace(min(difImg(:)),max(difImg(:)),128);
    %imgGr=uint8(arrayfun(@(x) find(abs(d(:)-x)==min(abs(d(:)-x))),log(difImg)));
    temp = double(difImg);
    %temp(temp>10)=10;


    %temp = temp - th +1;
    %temp(temp<=th) = 1;
    %temp = (temp) .* (-1) + 255 ;
    %temp(temp==255) = 0;
    %temp = 10*log(temp);
    %temp = 1 ./ temp;
    tempIdx = temp<=th;

    temp = arrayfun(@(x) (1+tanh(-0.5*(x-th))), temp); 
    %temp = arrayfun(@(x) (1/(x-th+0.1)), temp); 

    temp(tempIdx) = 0;

    %temp(temp==1) = 0;

    maxGl = max(temp,[],'all');

    imgGr = double((temp/maxGl)*128);

    %imgGr = uint8(temp);


    % imgGr(1:border,:)=0;
    % imgGr((end-border):end,:)=0;
    % imgGr(:,(end-border):end)=0;
    % imgGr(:,1:border)=0;

    %imageWrite(imgGr, './t7.bin');

    %fnd = find(imgGr);
    %[inliers,outliers] = rmoutliers(double(imgGr(fnd)));
    %imgGr(fnd(find(outliers))) = 0;
    
 
    %% Distance matrix

    dist = pdist2(pointVec,pointVec);

    c=1;
    pcSize = size(pointVec,1);
    distVec = zeros(pcSize*(pcSize-1)/2,1);
    distIdx = zeros(pcSize*(pcSize-1)/2,2);
    dist2 = zeros(size(dist));
    for i=1:pcSize
        %tree(i).a = i;
        %tree(i).l = [];
        %tree(i).r = [];
        for j=(i+1):pcSize
           gl1 = imgGr(pointVec(i,1),pointVec(i,2));
           gl2 = imgGr(pointVec(j,1),pointVec(j,2));
           %distVec(c) = sqrt( dist(i,j)^2 + (abs(double(gl2-gl1)))^2);
           %distyVec(c) = sqrt(dist(i,j)^2 + 0.01*(gl1^2 + gl2^2)) ;
           %distVec(c) = 1.0*(sqrt( dist(i,j)^2 + (abs(double(gl2-gl1)))^2) +  0.01*( gl1 + gl2 ) );
           %distVec(c) = dist(i,j) +  0.002*( gl1 + gl2 );
           distVec(c) = sqrt((dist(i,j))^2 + ccf*(gl1^2 + gl2^2));
           dist2(i,j) = distVec(c);
           dist2(j,i) = distVec(c);
           distIdx(c,:) = [i,j];
           c = c+1;
        end
    end


    [distSorted, distSortedIdx] = sort(distVec);
    edgesSorted = distIdx(distSortedIdx,:);

    %distSorted = distSorted./min(distSorted);
    %% Min span tree

    G = graph(edgesSorted(:,1)',edgesSorted(:,2)',distSorted);
    %p = plot(G,'EdgeLabel',G.Edges.Weight);
    [T,pred] = minspantree(G);
    %plot(T,'EdgeLabel',T.Edges.Weight);

    % init
    SpanTree = zeros(2*pcSize - 1,4);

    % fill
    spanEdges = T.Edges.Weight;
    [spanEdgesSorted, spanEdgesSortedIdx] = sort(spanEdges);


    for i=1:(pcSize-1)
        nodes = T.Edges.EndNodes(spanEdgesSortedIdx(i),:);
        n1 = nodes(1);
        n2 = nodes(2);
        while true
            if SpanTree(n1,4)==0
                break;
            end
            n1 = SpanTree(n1,4);
        end

        while true
            if SpanTree(n2,4)==0
                break;
            end
            n2 = SpanTree(n2,4);
        end

        SpanTree(n1,4) = pcSize + i;
        SpanTree(n2,4) = pcSize + i;
        SpanTree(pcSize + i, :) = [spanEdgesSorted(i),n1,n2,0];
    end

    % traverse span tree

    debugMat = zeros(pcSize,6);

    parfor i=(pcSize+1):(2*pcSize-1)
        cluster = getCluster(SpanTree, i);
        minDist = SpanTree(i,1);
        parent = SpanTree(i,4);
        if parent ~=0
            minDistPrim = SpanTree(parent,1);
        else
            minDistPrim = 0;
        end



        imgBk = uint8(zeros(size(bw)));

        whites = pointVec(cluster,:);
        for j=1:size(whites,1)
            ind1 = whites(j,1);
            ind2 = whites(j,2);
            imgBk(ind1,ind2) = ceil(imgGr(ind1, ind2));
        end
       % minDist
        i-pcSize
        minDistMat(i-pcSize) = minDist;
        if((minDistPrim - minDist)<0)
            logNfa(i-pcSize) = 0;
            debug = [];
        else
            %[logNfa(i-pcSize),debug,im2d] = computeClusterNFAv4(imgBk,size(whites,1),minDist, minDistPrim, pcSize);
            [logNfa(i-pcSize),debug] = computeClusterNFAv6(imgBk,size(whites,1),minDist, minDistPrim, pcSize);
        end

        if ~isempty(debug) , debugMat(i-pcSize,:)=debug; end
        %imwrite(im2d,['out/1/',int2str(i-pcSize),'.png']);
        clusterPrev = cluster;
        cluster = [];
    end
    %save('out/1/debug.mat','debugMat');
    logNfa(logNfa==inf) = 0;
    %bar(logNfa);


    %% Maximal clusters
    [nfaSorted, nfaSortedIdx] = sort(logNfa, 'descend');

    J = 0;
    for i=1:size(logNfa,2) 
        cluster = getCluster(SpanTree,nfaSortedIdx(i)+pcSize);

        repeated = 0;
        for j=1:J
            if ~isempty(intersect(maxClusters{j,1},cluster))
                repeated = 1;
                break;
            end
        end
        if repeated == 0
            J = J + 1;
            maxClusters{J,1} = cluster;
            maxClusters{J,2} = nfaSorted(i);

        end
    end

end

