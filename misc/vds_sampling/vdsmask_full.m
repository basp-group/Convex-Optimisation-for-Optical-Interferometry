function [mask]=vdsmask_full(N,M,p)

%Inputs
%N and M: Size of mask
%p: Coverage percentage
%d: Shape parameter that controls the density samplig

nb_meas=round(p*N*M);
tol=ceil(p*N*M)-floor(p*N*M);
d=1;


[x,y] = meshgrid(linspace(-1, 1, M), linspace(-1, 1, N)); % Cartesian grid
r = sqrt(x.^2+y.^2); r = r/max(r(:)); % Polar grid

alpha=-1;
it=0;
maxit=20;
while (alpha<-0.01 || alpha>0.01) && it<maxit
    pdf = (1-r).^d;
    [new_pdf,alpha] = modifyPDF(pdf, nb_meas);
    if alpha<0
        d=d+0.1;
    else
        d=d-0.1;
    end
    it=it+1;
end



mask = zeros(size(new_pdf));
while sum(mask(:))>nb_meas+tol || sum(mask(:))<nb_meas-tol
    mask = genMask(new_pdf);
end
