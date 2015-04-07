%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verlet integration for an Harmonic oscillator
% Matteo Salvalaglio
% last revision 23/02/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all 
close all

%%Initial conditions
r0=[1.0]; % Initial position
v0=[.5];  

m=[1.0];

dt=0.1;
final_time=5;
nsteps=floor(final_time./dt); %Total number of steps

k=2;
REQ=2;

r1=[];
v1=[];

r2=[];
v2=[];

% Forcefield
f=@(r,req) -m*k*(r-req);
V=@(r,req) 0.5*k*(r-req)^2;

Ke=@(v) 0.5*m*(v)^2;
dr=@(a,v_last)a*dt+v_last;

%% Integrate
time(1)=0;
time(2)=time(1)+dt;

% Position
r1(1)=r1_0;
r1(2)=r1(1)+v1_0*dt;

r2(1)=r2_0;
r2(2)=r2(1)+v2_0*dt;

POT(1)=V(r1(1),r2(1));

% First Partical
KIN(1)= Ke(v1_0) + Ke(v2_0);
H(1)=POT(1)+KIN(1);

% Second Partical
a=f(r1(2),REQ)/m;
v=dr(a,v1_0);
K1 = Ke(v);

a=f(r2(2),REQ)/m;
v=dr(a,v2_0);
K2 = Ke(v);

KIN(2) = K1+K2;
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
    r1(timestep+1)=2.*r1(timestep)-r1(timestep-1)+(dt.^2).*f(r1(timestep),REQ)./m;
    r2(timestep+1)=2.*r2(timestep)-r2(timestep-1)+(dt.^2).*f(r2(timestep),REQ)./m;
    
    %Compute velocity     
    v1(timestep)=(r1(timestep+1)-r1(timestep))./dt;
    v2(timestep)=(r2(timestep+1)-r2(timestep))./dt;
    
    % Potential Energy
    POT(timestep)=V(r1(timestep)-r2(timestep),REQ);
    
    % Kinetic Energy
    KIN(timestep)=0.5.*m.*v1(timestep).^2 + 0.5.*m.*v2(timestep).^2;
    
    % Total Energy
    H(timestep)=POT(timestep)+KIN(timestep);
    
    % Time
    time(timestep+1)=time(timestep)+dt;
    
    subplot(1,3,1)
    
    plot(...
        [-r1(timestep) ,+r2(timestep)],...
        [0, 0],'r-',...
        ...
        -r1(timestep),0,'ko',...
        +r1(timestep),0,'b+',...
        ...
        'MarkerSize',10,'MarkerFaceColor','w','LineWidth',5.0);
    
    
    set(gca,'FontSize',16)
    title('Cartesian Space')
    xlim([-10.0 10.0])
    ylim([-0.3 0.3])
    xlabel('\Delta{r}')
    
    set(gca,'XTick',[ ])
    set(gca,'YTick',[ ])

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
    ylim([0 0.6])
   
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


