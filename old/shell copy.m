% DATA  =  N x 12
% K     =  N x N
% INFO  =  {dim,time,clock,size,select}
% E     =  N x 1
% A     =  N x 3

function [PE,A] = shell (DATA,K,INFO)

    data_size = INFO.size;
    selector = INFO.select;
    domain = INFO.domain;
    dim = INFO.dim;
    dt = INFO.dt;

    pe = DATA(:,selector.data.pe);
    ke = DATA(:,selector.data.ke);
    x = DATA(:,selector.data.x);
    v = DATA(:,selector.data.v);
    a = DATA(:,selector.data.a);
    m = DATA(:,selector.data.m);

    unitary = ones(data_size(1),1);
    A = zeros(size(x));
    delta_norm = zeros(size(x,1));

    K=K*unitary*unitary'; %Stretch Matrix Hoizonal
    K=K-diag(diag(K)); %Set diaginal to zero




    for d = 1:dim
    	r =  (x(:,d) * unitary')'  -  (x(:,d) * unitary'); % Distance between each partial
        r = abs(r);
        collision = r-K;

        collision = logical(collision<eps) - eye(size(collision)); % Make logical matrix and remove diagonal
        collision = collision+collision'; %Make symmetric matrix (...if a hits b, than b hits a)
        collision = logical(collision); % Again make matrix logical
        %collision = collision - 2*tril(collision); % Conjugate matrix

        vv = v(:,d)
        mm = m
        r

        M = m*unitary';

        collision_M = collision.*M;
        delta_M =collision_M - collision_M'
        sum_M =collision_M + collision_M'

        momentum_transfer = collision.*(m'*v(:,d))
        induced_force = momentum_transfer/(dt^2)

        induced_acellation = induced_force./((m*unitary'))

        induced_acellation = sum(induced_acellation)'


        A(:,d)  = -(induced_acellation)


        pause
        clc


    end

    PE = pe;
end