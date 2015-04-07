%Generage Convergence Error
function [L,H] = conv(uh,u,M,K)
L = sqrt((u-uh)'*M*(u-uh));
H = sqrt((u-uh)'*M*(u-uh) + (u-uh)'*K*(u-uh));
end
        