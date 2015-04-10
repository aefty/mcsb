classdef mdsbSim < handle
    %SIMULATE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Access  = 'public')
        domain=[10,10,0];        
        t;
        dt;        
    end
    
    properties (SetAccess  = 'protected')    
        dynamics;
        model;
        K;
        Kl;
        
        
        data;
        boundary;
        dim;
        data_size;
    end
    
    properties (Access = 'private')        
        %Data selction distribtuion
        select_data=[1,4,7,10,13,14;
                    2,5,8,11,13,14;
                    3,6,9,12,13,14];
        
        select_data_X  =[1,2,3];
        select_data_V  =[4,5,6];
        select_data_A  =[7,8,9];
        select_data_F  =[10,11,12];        
        select_data_Pe =[13];  
        select_data_Ke =[14];  
        select_data_M  =[15];    
    end
    
    methods
        function this = mdsbSim(assembly,t,dt,domain)            
            
            this.t = t;
            this.dt = dt;
            
            this.dynamics = assembly.dynamics;
            this.dim =  assembly.dim;
            this.data = assembly.data;
            this.K = assembly.K;
            this.data_size =size(this.data);
            this.boundary = zeros(max(this.data_size),1);
            
            if(nargin > 4)
                this.domain = domain;
            end
            
            i = 1 ;
            for dynamic = this.dynamics
                temp = strsplit(char(dynamic),'|');
                dynamic_split = struct('name',char(temp(1)), 'location',char(temp(2)));
                this.dynamics{i} = dynamic_split;
                this.Kl(:,:).(dynamic_split.name) = logical(this.K.(dynamic_split.name));
                i=i+1;
            end
            
        end  
        
        function run(this)
            itr = this.t/this.dt;
            for i = 1:itr
                disp(sprintf('Progress  : %.0f%%',100*i/itr));
                
                for d = 1:this.dim
                    for j = 1:max(size(this.dynamics))
                                                
                        %Work Variables
                        DATA = this.data(:,this.select_data(d,:),i);
                        INFO = struct('domain',this.domain,'boundary',this.boundary,'dim',this.dim,'time',this.t,'clock',this.dt*i,'size',this.data_size);
                        K = this.K.(this.dynamics{j}.name);
                        
                        %Calucate Dyanmic
                        res = feval(this.dynamics{j}.name,DATA,K,INFO); 
                        
                        %Assigns Dynamic Potential Energy
                        this.data(:,this.select_data_Pe,i) = res(:,1);
                            
                        %Assign Dynamic Acceleration
                        this.data(:,this.select_data_A(d),i) = res(:,2) + this.data(:,this.select_data_A(d),i);
                    end
                    
                    %Position
                    this.data(:,this.select_data_X(d),i+1) = 0.5*this.data(:,this.select_data_A(d),i)*this.dt^2 + this.data(:,this.select_data_V(d),i)*this.dt + this.data(:,this.select_data_X(d),i);                           
                        
                    %Velocity
                    this.data(:,this.select_data_V(d),i+1) = (this.data(:,this.select_data_X(d),i+1) -this.data(:,this.select_data_X(d),i))/(this.dt);
                    
% %                     if( max(this.data(:,this.select_data_X(d),i+1)) > this.domain(d) || min(this.data(:,this.select_data_X(d),i+1)) <0 )
% %                         for n = 1:this.dSize
% %                             cond = (-2*(this.data(n,this.select_data_X(d),i+1) > this.domain(d) || this.data(n,this.select_data_X(d),i+1) <0) + 1) ;
% %                             this.boundary(i) = cond;
% %                         end
% %                     end
                    
                end
                
            end
        end
        
        function plot(this)
            %// Sample x and y values assumed for demo.
            x = this.data(:,this.select_data_X(1),:);
            y = this.data(:,this.select_data_X(2),:);
            z = this.data(:,this.select_data_X(3),:);
             
            s = this.data_size(1);
            cc=hsv(s);
            
            if(this.dim ==2)
                
                %// Plot point by point
                for k = 1:(this.t/this.dt)

                    subplot(1,2,1);
                    plot(x(:,k),y(:,k),'ro','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',20); %// Choose your own marker here
                    axis([0,this.domain(1),0,this.domain(2)]);
                    hold on
                    
                    for j = 1: max(size(this.dynamics))

                        link = find(triu(this.Kl.(this.dynamics{j}.name)));

                        for i = 1:size(link,1)
                            inx = link(i);
                            pointA = mod(inx,s);
                            pointB = 1+(inx - pointA)/s;
                            segX(i,:) = [x(pointA,k),x(pointB,k)];
                            segY(i,:) = [y(pointA,k),y(pointB,k)];
                        end

                        plot(segX',segY',':','LineWidth',2,'color',cc(j,:));
                        
                    end

                     F(k) = getframe;
                     clf; 
                end
            
            end
                      
            fps = floor(1/this.dt);
            movie(F,1,fps);
        end
        
        function [E,A]  = bindFunc(funcName, DATA,K,INFO)
            
            
            [E,A] = feval(funcName,{DATA,K,INFO});
            
        end
    end

end

