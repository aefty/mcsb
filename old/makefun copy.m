
% Spring Dynamics (Relative Coordinents)
mdsbModel.spring.A =  function (DATA,GAMMA,SIZE,K) 
 -K.*(     (DATA(:,1,end)*ones(1,SIZE(1)))'  -  (DATA(:,1,end)*ones(1,SIZE(1))) );
 
mdsbModel.spring.Pe = @(DATA,GAMMA,SIZE,K) 0.5*K.*( (DATA(:,1,end)*ones(1,SIZE(1)))'  -  (DATA(:,1,end)*ones(1,SIZE(1))) ).^2;

% Wall
mdsbModel.wall.A =  @(DATA,GAMMA,SIZE,K) disp(GAMMA);



% Replulstion
mdsbModel.rep.A =  @(DATA,GAMMA,SIZE,K) -K*abs(DATA(:,2,end));