function [ output,mask ]= GPCT_D(img,maxorder,alpha)
[N, M]  = size(img);
x       = -1+1/M:2/M:1-1/M;
y       = 1-1/N:-2/N:-1+1/N;
[X,Y]   = meshgrid(x,y);
[th, r]  = cart2pol(X, Y);
pz=th<0;
theta =zeros(N,M);
theta(pz)     = th(pz) + 2*pi;
theta(~pz)     = th(~pz);
pz=r>1;
rho =zeros(N,M);
rho(pz)     = 10;
rho(~pz)     = r(~pz); 
output=zeros(maxorder+1,2*maxorder+1);
mask=ones(maxorder+1,2*maxorder+1);
for order=0:1:maxorder
    R=getRadialPoly(order,rho,alpha);       % get the radial polynomial
    for repetition=-maxorder:1:maxorder
        pupil =R.*exp(-1j*repetition * theta);
        Product = double(img) .* pupil;
        cnt = nnz(R)+1;
        if repetition==0
            mask(order+1,repetition+maxorder+1)=0;
        end
        output(order+1,repetition+maxorder+1)=sum(Product(:))*(1/(2*pi))*(4/cnt);
    end
end
end

function [output] = getRadialPoly(order,rho,alpha)
% compute the radial polynomial
if order==0
    output=sqrt(alpha*rho.^(alpha-2));
else
    output=sqrt(alpha*rho.^(alpha-2)).*sqrt(2).*cos(pi*order.*rho.^alpha);
end
end % end getRadialPoly method
