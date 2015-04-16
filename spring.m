% DATA  =  N x 12
% K     =  N x N
% INFO  =  {dim,time,clock,size,select}
% E     =  N x 1
% A     =  N x 3

function [E,A] = spring (DATA,K,INFO)

    data_size = INFO.size;
    selector = INFO.select;
    domain = INFO.domain;
    dim = INFO.dim;

    e = DATA(:,selector.data.pe);
    x = DATA(:,selector.data.x);
    a = DATA(:,selector.data.a);
    m = DATA(:,selector.data.m);

    unitary = ones(1,data_size(1));
    A = zeros(size(x));
    delta_norm = zeros(size(x,1));

    for d = 1:dim
    	delta =  (x(:,d) * unitary)'  -  (x(:,d) * unitary);
		A(:,d) = sum(-K.*delta)'./m;
		delta_norm = delta_norm + delta.^2;
    end

    E = sum(0.5.*K.*(delta_norm))'./4; %Note K_total^2 = (K_each/2)^2, thus we devide by 4 at the end
end