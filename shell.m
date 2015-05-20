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

    K=K*unitary*unitary'; %Stretch Matrix Horizontal
    K=K-diag(diag(K)); %Set diagonal to zero

    net_delta = zeros(data_size(1));

    for d = 1:dim
        xx =x(:,d);
    	r =  (x(:,d) * unitary')'  -  (x(:,d) * unitary'); % Distance between each partial

        temp= abs(r)-K ;% Distance between each shell

        delta(:,:,d)=temp;
        net_delta = net_delta+temp.^2;
    end

    net_delta=net_delta.^(0.5);
    collision = net_delta - K;
    collision = logical(collision<0);

    delta

    collision

    A = a;

    %A(:,1)=sum(2*delta(:,:,1).*net_delta/(dt^2))';
    %A(:,2)=sum(2*delta(:,:,2).*net_delta/(dt^2))';







    disp('----');


    pause
    clc


    PE = pe;
end