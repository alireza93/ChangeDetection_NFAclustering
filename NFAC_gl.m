function [maxClusters, pointVec, debugMat] = NFAC_gl(difImg,ccf,th)
    s1 = size(difImg,1);
    s2 = size(difImg,2);
    border = 1;

    %% binary threshold 


    bw = ones(ceil(size(difImg)));
    temp = difImg;

    temp(temp<=th) = 0;
    temp(temp>th) = 1;
    bw = bw & temp;
    %% Recover seed points



    [rows,cols] = find(bw);
    pointVec = [rows,cols];

    %% function
    %d=linspace(min(difImg(:)),max(difImg(:)),128);
    %imgGr=uint8(arrayfun(@(x) find(abs(d(:)-x)==min(abs(d(:)-x))),log(difImg)));
    temp = double(difImg);
    tempIdx = temp<=th;

    temp = arrayfun(@(x) (1+tanh(-0.5*(x-th))), temp); 
    temp(tempIdx) = 0;
    maxGl = max(temp,[],'all');
    imgGr = double((temp/maxGl)*128);

 
    %% Distance matrix

    dist = pdist2(pointVec,pointVec);

    c=1;
    pcSize = size(pointVec,1);
    distVec = zeros(pcSize*(pcSize-1)/2,1);
    distIdx = zeros(pcSize*(pcSize-1)/2,2);
    dist2 = zeros(size(dist));
    for i=1:pcSize
        for j=(i+1):pcSize
           gl1 = imgGr(pointVec(i,1),pointVec(i,2));
           gl2 = imgGr(pointVec(j,1),pointVec(j,2));
           distVec(c) = sqrt((dist(i,j))^2 + ccf*(gl1^2 + gl2^2));
           dist2(i,j) = distVec(c);
           dist2(j,i) = distVec(c);
           distIdx(c,:) = [i,j];
           c = c+1;
        end
    end


    [distSorted, distSortedIdx] = sort(distVec);
    edgesSorted = distIdx(distSortedIdx,:);
    %% Min span tree

    G = graph(edgesSorted(:,1)',edgesSorted(:,2)',distSorted);    
    [T,pred] = minspantree(G);

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
        %i-pcSize
        minDistMat(i-pcSize) = minDist;
        if((minDistPrim - minDist)<0)
            logNfa(i-pcSize) = 0;
            debug = [];
        else
            
            [logNfa(i-pcSize),debug] = computeClusterNFA(imgBk,size(whites,1),minDist, minDistPrim, pcSize);
        end

        if ~isempty(debug) , debugMat(i-pcSize,:)=debug; end
    end
    
    logNfa(logNfa==inf) = 0;
    
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

