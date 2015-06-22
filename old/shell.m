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

    x = DATA(:,selector.data.x);
    v = DATA(:,selector.data.v);
    a = DATA(:,selector.data.a);
    m = DATA(:,selector.data.m);
    pe = DATA(:,selector.data.pe);

    potential_well = .1;

    unitary = ones(1,data_size(1));
    I = eye(data_size(1));
    A = zeros(size(x));
    delta_norm = zeros(size(x,1));

    for d = 1:dim
        rx =  (x(:,d) * unitary)' - (x(:,d) * unitary); % Distance between each particle
        map = abs(rx);
        map(map<eps)=0;
        map(map~=0)=-1;
        map=map+1
        %pause

        vx =  (v(:,d) * unitary)' - (v(:,d) * unitary); % Relative Velocity
        ax = -2*vx.*map./dt;
        A(:,d) = sum(ax)';
    end

    PE = pe;
end