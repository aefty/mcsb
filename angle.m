
%% PE = Potential Energoy
%% A  = Acceleration
%% DATA = Data Table
%% REL  = Relative Position Matrix
%% K    = Dynamics Relation Matrix
%% INFO = Variouse Parameteres

function [PE,A] = angle (DATA,REL,K,INFO)

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
    r(:,:,1)=r(:,:,1)-diag(diag(r(:,:,1)))+eye(size(r(:,:,1)));

    r_norm = REL.r_norm;
    r_theta = REL.r_theta;

    K = K.*0.0174532925;

    ang = atan(r(:,:,2)./r(:,:,1));

    %pause

    delAng = (ang-K);

    A = zeros(size(x));
    F = -2*delAng./r_norm.^2;

    for d = 1:dim
        A(:,d) = sum(F.* r_theta(:,:,d))'./m;
    end

    E = K.*(delAng).^2;
    PE = sum(E)';
end