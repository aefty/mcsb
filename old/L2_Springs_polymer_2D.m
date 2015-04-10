%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Verlet integration for an Harmonic oscillator
% Matteo Salvalaglio
% last revision 23/02/2015
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all 
close all



%%Initial conditions

 x0=[1 2 3 3 3 2 1 1].*2.5;       %[00.2 1.05 1.90 3.2 4.5 4.8].*2.5;
 y0=[1 1 1 2 3 3 3 2].*2.5;

%x0=[1:8].*2.5./sqrt(2)
%y0=[1:8].*2.5./sqrt(2)



v0=5.*(rand(2,8)-0.5);

dt=0.1;
m=[1.0 1.0 1.0 1.0 1.0 1.0 1.0 1.0 ];

final_time=500;
nsteps=floor(final_time./dt); %Total number of steps


% Constants

k=10.0;
req=2.5;
HS=1E1

% Topology

M=[0 1 0 0 0 0 0 0
   1 0 1 0 0 0 0 0
   0 1 0 1 0 0 0 0
   0 0 1 0 1 0 0 0
   0 0 0 1 0 1 0 0
   0 0 0 0 1 0 1 0
   0 0 0 0 0 1 0 1
   0 0 0 0 0 0 1 0];

k=k.*M;

 
%% Integrate
xp=x0;
x=xp+v0(1,:).*dt;
yp=y0;
y=yp+v0(2,:).*dt;

time(1)=0;
time(2)=time(1)+dt;

POT=[0 0];
KIN=[0 0];
H=[0 0];
timestep=2;


%Initialize figure
hFig=figure(1);
%set(hFig,'Position',[100 100 450 800])
set(hFig,'Position',[100 100 1200 450])

    subplot(1,2,1)
    h1=plot(x-mean(x),y-mean(y),'r-',x-mean(x),y-mean(y),'ko','MarkerSize',35,'MarkerFaceColor','w','LineWidth',5.0);
    set(gca,'FontSize',16)
    title('Cartesian Space')
    xlabel('X')
    ylabel('Y')
    %set(gca,'XTick',[ ])
    %set(gca,'YTick',[ ])
    
    xlim([-10 10])
    ylim([-10 10])
    drawnow
    
    
    subplot(1,2,2)
    set(gca,'FontSize',16)
    hold on
    box on
    h2=plot(time,KIN+POT,'b.','LineWidth',1.5);
    title('Energy Conservation')
    xlabel('Time')
    ylabel('Energy')
    %ylim([5 15])
    drawnow

    
    
    




%Initialize Movie
% writerObj = VideoWriter('Harmonic.avi');
% open(writerObj);


while timestep<nsteps-3
    
    
    %COMPUTE DISTANCES
    fx=zeros(1,length(x0))';  
    fy=zeros(1,length(x0))';  
    POT(timestep)=0;
    for i=1:length(x0)-1
        for j=i+1:length(x0)
            r=sqrt(((x(i)-x(j)).^2)+((y(i)-y(j)).^2));
            
            
            cx=-(k(i,j).*(r-req)-2.*HS/(r.^3)).*((x(i)-x(j)))./r;
            cy=-(k(i,j).*(r-req)-2.*HS/(r.^3)).*((y(i)-y(j)))./r;
            
            
            fx(i)=fx(i)+cx;      
            fx(j)=fx(j)-cx;
            
            fy(i)=fy(i)+cy;
            fy(j)=fy(j)-cy;
           
            POT(timestep)=POT(timestep)+0.5.*k(i,j).*(r-req).^2+1.*HS./r.^2;
           
            end
    end
       
    %Verlet integration
    
     for i=1:length(x0)
        r=sqrt(x(i).^2+y(i).^2);
        xnew(i)=2.*x(i)-xp(i)+(dt.^2).*fx(i)./m(i);
        ynew(i)=2.*y(i)-yp(i)+(dt.^2).*fy(i)./m(i);
     end  
         
      
    
    %Compute velocity     
    vx=(xnew-xp)./2./dt;
    vy=(ynew-yp)./2./dt;
    
    v=sqrt(vx.^2+vy.^2);
    
    % Kinetic Energy
    KIN(timestep)=sum(0.5.*m.*v.^2);
    
    if timestep==2
    POT(1)=POT(2)
    KIN(1)=KIN(2)
    end
    
   
    time(timestep)=time(timestep-1)+dt;
    
    set(h1,'XData',xnew-mean(xnew),'YData',ynew-mean(ynew));
    set(h2,'XData',time,'YData',KIN+POT);
    drawnow
    
    
%     namefile=['current_frame.png'];
%     screen2png(namefile)
%     thisimage = imread(namefile);
%     writeVideo(writerObj, thisimage);
    
     % Time
    xp=x;
    x=xnew;
    yp=y;
    y=ynew;
    
    % update timestep
    timestep=timestep+1;
    
end
%close(writerObj);


