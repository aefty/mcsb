%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verlet integration for an Harmonic oscillator
% Matteo Salvalaglio
% last revision 23/02/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all 
close all

%%Initial conditions

r0=1.0; % Initial position
v0=.5;  
dt=0.1;
m=1.0;

final_time=5;
nsteps=floor(final_time./dt); %Total number of steps

k=2;
req=2;

r=[];
% Forcefield
f=@(r) -m*k*(r-req);
V=@(r) 0.5*k*(r-req)^2;

Ke=@(v) 0.5*m*(v)^2;
dr=@(a,v_last)a*dt+v_last;

%% Integrate
r(1)=r0;
r(2)=r(1)+v0.*dt;

time(1)=0;
time(2)=time(1)+dt;

POT(1)=V(r(1));
POT(2)=V(r(2));

KIN(1)=Ke(v0);

a=f(r(2))/m;
v=dr(a,v0);
KIN(2)=Ke(v);

H(1)=POT(1)+KIN(1);
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
    r(timestep+1)=2.*r(timestep)-r(timestep-1)+(dt.^2).*f(r(timestep))./m;
    
    %Compute velocity     
    v(timestep)=(r(timestep+1)-r(timestep))./dt;
    
    % Potential Energy
    POT(timestep)=V(r(timestep));
    
    % Kinetic Energy
    KIN(timestep)=0.5.*m.*v(timestep).^2;
    
    % Total Energy
    H(timestep)=POT(timestep)+KIN(timestep);
    
    % Time
    time(timestep+1)=time(timestep)+dt;
    
    subplot(1,3,1)
    
    plot(...
        [-r(timestep)./2 r(timestep)./2],...
        [0 0],'r-',...
        ...
        -r(timestep)./2,0,'ko',...
        r(timestep)./2,0,'ko',...
        ...
        'MarkerSize',35,'MarkerFaceColor','w','LineWidth',5.0);
    
    
    set(gca,'FontSize',16)
    title('Cartesian Space')
    xlim([-2.0 2.0])
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
        r(3:end-1),v(3:end)./m,...
        r(timestep),v(timestep)./m,'ro',...
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

sum(sum(r))


