function [result] = compare(img_ref,img_test)
border = 2;

result = difMap(img_ref,img_test,0,0,1);

result(result<=0)=min(abs(result),[],'all');
result(end-border:end,:)=0;
result(1:border,:)=0;
result(:,end-border:end)=0;
result(:,1:border)=0;
    
end

