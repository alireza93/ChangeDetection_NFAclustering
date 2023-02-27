function [ dE94 ] = calcCIE94(lab1, lab2)
%calcCIE94 calculates color difference with CIE94 formula
for i=1:size(lab1,1)
    a1 = lab1(i,2); a2 = lab2(i,2);
    b1 = lab1(i,3); b2 = lab2(i,3);
    L1 = lab1(i,1); L2 = lab2(i,1);

    dL = L1 - L2;
    da = a1 - a2;
    db = b1 - b2;
    c1 = sqrt(a1*a1+b1*b1);
    c2 = sqrt(a2*a2+b2*b2);
    dc = c1 - c2;
    dh = sqrt(da*da + db*db - dc*dc);
    sl = 1;
    sc = 1 + 0.045*c1;
    sh = 1 + 0.015*c1;
    dE94(i) = sqrt((dL/sl)^2 + (dc/sc)^2 + (dh/sh)^2);
end
end

