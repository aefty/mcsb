%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verlet integration for an Harmonic oscillator
% Matteo Salvalaglio -  Aryan E. Edited
% last revision 23/02/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all 
close all

%%Initial conditions
r1_0=0; % Initial position
v1_0=0;  

r2_0=1.0; % Initial position
v2_0=0;  

r3_0=2.0; % Initial position
v3_0=0;  

m=1.0;

dt=0.1;
final_time=10;
nsteps=floor(final_time./dt); %Total number of steps

k=1;
REQ=2;

r1=[];
v1=[];

r2=[];
v2=[];

r3=[];
v3=[];

POT=[];
KIN=[];
H=[];

% Forcefield
f=@(rb,ra) -m*k*(REQ-(rb-ra));
V=@(rb,ra) 0.5*k*(REQ-abs(rb-ra))^2;

Ke=@(v) 0.5*m*(v)^2;
dr=@(a,v_last) a*dt+v_last;

%% Integrate

% First Step
time(1)=0;
r1(1)=r1_0;
v1(1)=v1_0;

r2(1)=r2_0;
v2(1)=v2_0;

r3(1)=r3_0;
v3(1)=v3_0;

POT(1)=V(r2(1),r1(1)) + V(r3(1),r2(1));
KIN(1)= Ke(v1(1)) + Ke(v2(1))+ Ke(v3(1));
H(1)=POT(1)+KIN(1);

% Second Step
time(2)=time(1)+dt;

v1(2) = (f(r2(1),r1(1))/m)*dt + v1(1);
r1(2)=r1(1)+v1(2)*dt;

v2(2) = dt*(-f(r2(1),r1(1))+f(r3(1),r2(1)))/m + v2(1);
r2(2)=r2(1)+v2(2)*dt;

v3(2) = (-f(r3(1),r2(1))/m)*dt + v3(1);
r3(2)=r3(1)+v3(2)*dt;

POT(2)=V(r2(2),r1(2))+V(r3(2),r2(2));
KIN(2)= Ke(v1(2)) + Ke(v2(2))+ Ke(v3(2));
H(2)=POT(2)+KIN(2);

timestep=2

%Initialize figure
hFig=figure(1);
%set(hFig,'Position',[100 100 450 800])
set(hFig,'Position',[100 100 1200 450])

%Initialize Movie
%writerObj = VideoWriter('Harmonic.avi');
%open(writerObj);

while timestep<nsteps-3
    
    %Verlet integration
    r1(timestep+1)=2*r1(timestep)-r1(timestep-1)+(dt^2)*f(r2(timestep),r1(timestep))./m;
    r2(timestep+1)=2*r2(timestep)-r2(timestep-1)+(dt^2)*(-f(r2(timestep),r1(timestep))+f(r3(timestep),r2(timestep)))./m;
    r3(timestep+1)=2*r3(timestep)-r3(timestep-1)+(dt^2)*-f(r3(timestep),r2(timestep))./m;
    
    %Compute velocity     
    v1(timestep)=(r1(timestep+1)-r1(timestep))/dt;
    v2(timestep)=(r2(timestep+1)-r2(timestep))/dt;
    v3(timestep)=(r3(timestep+1)-r3(timestep))/dt;
    
    % Potential Energy
    POT(timestep)=V(r2(timestep),r1(timestep))+V(r3(timestep),r2(timestep));
    
    % Kinetic Energy
    KIN(timestep)=Ke(v1(timestep)) + Ke(v2(timestep))+ Ke(v3(timestep));
    
    % Total Energy
    H(timestep)=POT(timestep)+KIN(timestep);
    
    % Time
    time(timestep+1)=time(timestep)+dt;
    
    subplot(1,3,1)
    
    plot(...
        [r1(timestep) ,r2(timestep),r3(timestep)],...
        [0,0, 0],'r-',...
        ...
        r1(timestep),0,'ko',...
        r2(timestep),0,'b+',...
        r3(timestep),0,'rs',...
        ...
        'MarkerSize',10,'MarkerFaceColor','w','LineWidth',5.0);
    
    
    set(gca,'FontSize',16)
    title('Cartesian Space')
    xlim([-3.0 10.0])
   % ylim([-0.3 0.3])
    xlabel('\Delta{r}')
    
    %set(gca,'XTick',[ ])
    %set(gca,'YTick',[ ])

    subplot(1,3,3)
    set(gca,'FontSize',16)
    title('Energy Conservation')
    
    plot(...
        time(1:end-1),POT,'b-',...
        time(1:end-1),KIN,'g-',...
        time(1:end-1),H,'r-',...
        ...
        time(timestep),POT(timestep),'bo',...
        time(timestep),KIN(timestep),'go',...
        time(timestep),H(timestep),'ro',...
        ...
        'MarkerSize',10,'MarkerFaceColor','w');
    
    legend('Potential','Kinetic','Total')
    title('Energy Conservation')
    xlabel('Time')
    ylabel('Energy')
    %ylim([0 0.6])
   
    subplot(1,3,2)
    set(gca,'FontSize',16)
    plot(...
        r1(3:end-1),v1(3:end)./m,...
        r1(timestep),v1(timestep)./m,'ro',...
        'MarkerSize',10,'MarkerFaceColor','w');
    
    title('Phase Space');
    xlabel('Position')
    ylabel('Momentum')
    
    drawnow
    
%     namefile=['current_frame.png'];
%     screen2png(namefile)
%     thisimage = imread(namefile);
%     writeVideo(writerObj, thisimage);
   
    % update timestep
    timestep=timestep+1;
    
end
%close(writerObj);

sum(sum(H))


