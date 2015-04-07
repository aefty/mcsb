
% Spring Dynamics (Relative Coordinents)
model.spring.A =  @(DATA,GAMMA,SIZE,K) -K.*(     (DATA(:,1,end)*ones(1,SIZE(1)))'  -  (DATA(:,1,end)*ones(1,SIZE(1))) );
model.spring.Pe = @(DATA,GAMMA,SIZE,K) 0.5*K.*( (DATA(:,1,end)*ones(1,SIZE(1)))'  -  (DATA(:,1,end)*ones(1,SIZE(1))) ).^2;

% Wall
model.wall.A =  @(DATA,GAMMA,SIZE,K) disp(GAMMA);



% Replulstion
model.rep.A =  @(DATA,GAMMA,SIZE,K) -K*abs(DATA(:,2,end));