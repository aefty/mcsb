% DATA  =  N x 12
% K     =  N x N
% INFO  =  {dim,time,clock,size,select}
% E     =  N x 1
% A     =  N x 3

function [PE,A] = lj_1 (DATA,K,INFO)

    data_size = INFO.size;
    selector = INFO.select;
    domain = INFO.domain;
    dim = INFO.dim;

    x = DATA(:,selector.data.x);
    v = DATA(:,selector.data.v);
    a = DATA(:,selector.data.a);
    m = DATA(:,selector.data.m);

    potential_well = 1;

    unitary = ones(1,data_size(1));
    I = eye(data_size(1));
    A = zeros(size(x));
    delta_norm = zeros(size(x,1));

    for d = 1:dim
        r =  (x(:,d) * unitary)' - (x(:,d) * unitary); % Distance between each particle
        r(r<1e-10) = 1e-10;
        r_ = r+I;
        F = (-12.* K.^12 .* r_.^(-13) + 12.* K.^6 .* r_.^(-7) );
        A(:,d) = potential_well.* sum(F)'./m;
        delta_norm = delta_norm + r.^2;
    end

    delta_norm_ = delta_norm+I;
    E = K.^12 .* delta_norm_.^(-12)  -  K.^6 .* delta_norm_.^(-6);

    PE = potential_well.* sum(E)'./2; %Note K_total^2 = (K_each/2)^2, thus we divide by 4 at the end
end