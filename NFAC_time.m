function [maxClusters] = NFAC_time(pointVec,cubeSize)
    dist = pdist2(pointVec,pointVec);

    c=1;
    pcSize = size(pointVec,1);
    distVec = zeros(pcSize*(pcSize-1)/2,1);
    distIdx = zeros(pcSize*(pcSize-1)/2,2);
    for i=1:pcSize
        for j=(i+1):pcSize
            distVec(c) = dist(i,j);
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



        im3d = uint8(zeros(cubeSize));

        whites = pointVec(cluster,:);
        for j=1:size(whites,1)
            ind1 = whites(j,1);
            ind2 = whites(j,2);
            ind3 = whites(j,3);
            im3d(ind1,ind2,ind3+1) = 255;
        end
        minDistMat(i-pcSize) = minDist;
        
        logNfa(i-pcSize) = compute3DClusterNFA(im3d,size(whites,1),minDist, minDistPrim, pcSize);
        clusterPrev = cluster;
        cluster = [];
    end
    logNfa(logNfa==inf) = 0;

    % Maximal clusters
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

