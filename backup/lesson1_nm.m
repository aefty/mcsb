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

r1=1.0; % Initial position
v1=.5; 

r2=1.0; % Initial position
v2=.5; 

m0=1.0;
m1=1.0;
m2=1.0;

dt=0.1;

final_time=10;
nsteps=floor(final_time./dt); %Total number of steps

k0=2;
k1=2;
k2=2;

r=[];

M = [...
    m0,0,0;...
    0,m1,0;...
    0,0,m2;...   
    ];

K = [...
    -(k0+k1),k2,0;...
    k2,-(k2+k3),k3;...
    0,k3,-(k3+k4);...   
    ];

K = inv(A)*K;

F = K*r;



%Initialize figure
hFig=figure(1);
%set(hFig,'Position',[100 100 450 800])
set(hFig,'Position',[100 100 1200 450])

while timestep<nsteps-3
    
    M
    
    
    %Verlet integration
    r(timestep+1)=2.*r(timestep)-r(timestep-1)+(dt.^2).*f(r(timestep))./m;
    
    %r(timestep+1)=2.*r(timestep)-r(timestep-1)+(dt.^2).*f(r(timestep))./m;
  
    
    
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
        [-r(timestep)./2 , r(timestep)./2],...
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
close(writerObj);


