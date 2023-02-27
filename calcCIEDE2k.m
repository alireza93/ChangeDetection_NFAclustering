function [ dE2k ] = calcCIEDE2k(lab1, lab2)

for i=1:size(lab1,1)
    a1 = lab1(i,2); a2 = lab2(i,2);
    b1 = lab1(i,3); b2 = lab2(i,3);
    L1 = lab1(i,1); L2 = lab2(i,1);
    
    kl = 1; kc=1; kh =1;
    
    Cab1 = sqrt(a1^2+b1^2);
    Cab2 = sqrt(a2^2+b2^2); 
    Cabarithmean = (Cab1 + Cab2)/2;
    G = 0.5* ( 1 - sqrt( (Cabarithmean^7)/(Cabarithmean^7 + 25^7)));

    apstd = (1+G)*a1; 
    apsample = (1+G)*a2; 
    Cpsample = sqrt(apsample^2+b2^2);
    Cpstd = sqrt(apstd^2+b1^2);
    Cpprod = (Cpsample*Cpstd);
    zcidx = find(Cpprod == 0);


    hpstd = atan2(b1,apstd);
    hpstd = hpstd+2*pi*(hpstd < 0);
    hpstd(find( (abs(apstd)+abs(b1))== 0) ) = 0;
    hpsample = atan2(b2,apsample);
    hpsample = hpsample+2*pi*(hpsample < 0);
    hpsample(find( (abs(apsample)+abs(b2))==0) ) = 0;

    dL = (L2-L1);
    dC = (Cpsample-Cpstd);
    dhp = (hpsample-hpstd);
    dhp = dhp - 2*pi* (dhp > pi );
    dhp = dhp + 2*pi* (dhp < (-pi) );
    dhp(zcidx ) = 0;

    dH = 2*sqrt(Cpprod)*sin(dhp/2);
    Lp = (L2+L1)/2;
    Cp = (Cpstd+Cpsample)/2;
    hp = (hpstd+hpsample)/2;
    hp = hp - ( abs(hpstd-hpsample)  > pi ) *pi;
    hp = hp+ (hp < 0) *2*pi;
    hp(zcidx) = hpsample(zcidx)+hpstd(zcidx);

    Lpm502 = (Lp-50)^2;
    Sl = 1 + 0.015*Lpm502/sqrt(20+Lpm502);  
    Sc = 1+0.045*Cp;
    T = 1 - 0.17*cos(hp - pi/6 ) + 0.24*cos(2*hp) + 0.32*cos(3*hp+pi/30) ...
        -0.20*cos(4*hp-63*pi/180);
    Sh = 1 + 0.015*Cp*T;
    delthetarad = (30*pi/180)*exp(- ( (180/pi*hp-275)/25)^2);
    Rc =  2*sqrt((Cp^7)/(Cp^7 + 25^7));
    RT =  - sin(2*delthetarad)*Rc;

    klSl = kl*Sl;
    kcSc = kc*Sc;
    khSh = kh*Sh;

    dE2k(i) = sqrt( (dL/klSl)^2 + (dC/kcSc)^2 + (dH/khSh)^2 + RT*(dC/kcSc)*(dH/khSh) );

end

end

