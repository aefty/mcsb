
%% PE = Potential Energoy
%% A  = Acceleration
%% DATA = Data Table
%% REL  = Relative Position Matrix
%% K    = Dynamics Relation Matrix
%% INFO = Variouse Parameteres

function [PE,A] = bond (DATA,REL,K,INFO)

    data_size = INFO.size;
    selector = INFO.select;
    domain = INFO.domain;
    dim = INFO.dim;

    e = DATA(:,selector.data.pe);
    x = DATA(:,selector.data.x);
    v = DATA(:,selector.data.v);
    a = DATA(:,selector.data.a);
    m = DATA(:,selector.data.m);

    r = REL.r;
    r_norm = REL.r_norm;
    r_theta = REL.r_theta;

    r_relax =.01;

    r_norm = (r_norm-r_relax);


    A = zeros(size(x));
    F = -K.*r_norm;

    for d = 1:dim
        A(:,d) = sum(F.* r_theta(:,:,d))'./m;
    end

    E = 0.5.*K.*(r_norm./2).^2;
    PE = sum(E)';
end