function angular_filter_bank(BW,fname)
close all;
%---------------
%parameters
%---------------
FFTN    =   32;%64;%32;
TSTEPS  =   12; %15 degrees interval
DELTAT  =   pi/TSTEPS;
%---------------
%precompute
%---------------
[x,y]   =   meshgrid(-FFTN/2:FFTN/2-1,-FFTN/2:FFTN/2-1);
r       =   sqrt(x.^2+y.^2);
th      =   atan2(y,x);
th(th<0)=   th(th<0)+2*pi;  %unsigned
filter  =   [];

%-------------------------
%generate the filters
%-------------------------
for t0  =   0:DELTAT:(TSTEPS-1)*DELTAT
     t1     = t0+pi;                                %for the other lobe
     %-----------------
     %first lobe
     %-----------------
     d          = angular_distance(th,t0);
     msk        = 1+cos(d*pi/BW); 
     msk(d>BW)  = 0;
     rmsk       = msk;                              %save first lobe

     %-----------------
     %second lobe
     %-----------------
     d          = angular_distance(th,t1);
     msk        = 1+cos(d*pi/BW); 
     msk(d>BW)  = 0;
     rmsk       = (rmsk+msk);

     imagesc(rmsk);pause;
     rmsk   = transpose(rmsk);
     filter = [filter,rmsk(:)];
end;
     %-----------------
     %save the filters
     %-----------------
     angf  = filter;
     eval(sprintf('save %s angf',fname));

%----------------------
%write to a C file
%----------------------
fp = fopen(sprintf('%s.h',fname),'w');
fprintf(fp,'{\n');
for i = 1:size(filter,2)
    i
    k = 1;
    fprintf(fp,'{');
    for j = 1:size(filter,1)
        fprintf(fp,'%f,',filter(j,i));
        if(k == 32) k=0; fprintf(fp,'\n'); end;
        k = k+1;
    end;
    fprintf(fp,'},\n');
end;
fprintf(fp,'};\n');
fclose(fp);
%end function radial_filter_bank

%-----------------------------------------
%angular_distance
%computes angular distance-acute angle 
%-----------------------------------------
function d = angular_distance(th,t0)
    d = abs(th-t0);
    d = min(d,2*pi-d);
%end function angular_distance
