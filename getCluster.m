function [cluster] = getCluster(SpanTree, node)
    
    if SpanTree(node,2)==0 || SpanTree(node,3)==0
        cluster = [node];
    else
        cluster = [getCluster(SpanTree,SpanTree(node,2)),getCluster(SpanTree,SpanTree(node,3))];
    end

end