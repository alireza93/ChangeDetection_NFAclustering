function [ dE ] = calcCIELab(lab1, lab2)
%calcCIE94 calculates color difference with CIELab formula
for i=1:size(lab1,1)
    a1 = lab1(i,2); a2 = lab2(i,2);
    b1 = lab1(i,3); b2 = lab2(i,3);
    L1 = lab1(i,1); L2 = lab2(i,1);
    dE(i) = sqrt((L1 - L2)^2 + (a1 - a2)^2 + (b1 - b2).^2);
end
end

