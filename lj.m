
%% PE = Potential Energoy
%% A  = Acceleration
%% DATA = Data Table
%% REL  = Relative Position Matrix
%% K    = Dynamics Relation Matrix
%% INFO = Variouse Parameteres
function [PE,A] = lj (DATA,REL,K,INFO)

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


    potential_well = 1;
    threshhold = max(max(K))*.9;

    %threshhold =max(.2,(1/max(max(abs(v))))^13);
    map = abs(r_norm);
    map(map<=threshhold)=0;
    map(map>threshhold)=1;
    r_norm =r_norm.*map;
    r_norm(r_norm==0)=threshhold;

    A = zeros(size(x));
    F = -potential_well*(-12.* K.^12 .* r_norm.^(-13) + 6.* K.^6 .* r_norm.^(-7));
    F = F - diag(diag(F));

    for d = 1:dim
        A(:,d) = sum(F.* r_theta(:,:,d))'./m;
    end

    E = abs(potential_well.*((K./r_norm).^(12)  - (K./r_norm).^(6)));
    E = E - diag(diag(E));
    %pause
    PE = sum(E)';
end