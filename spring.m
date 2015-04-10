function [E,A] = spring (DATA,K,INFO)

    SIZE = INFO.size;
    A = -K.*( (DATA(:,1,end) * ones(1,SIZE(1)))'  -  (DATA(:,1,end)*ones(1,SIZE(1))) );
    E = 0.5*K.*( (DATA(:,1,end)*ones(1,SIZE(1)))'  -  (DATA(:,1,end)*ones(1,SIZE(1))) ).^2;

 end