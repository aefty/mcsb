classdef simulate < handle
    %SIMULATE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        domain=[10,10,0];
        t;
        dt;
        dynamics;
        
        model;
        K;
        Kl;
        
        env;
        data;
        gamma;
        dim;
        dSize;
        
        %Data selction distribtuion
        selectData=[1,4,7,10,13,14;
                    2,5,8,11,13,14;
                    3,6,9,12,13,14];
        
        selectDataX  =[1,2,3];
        selectDataV  =[4,5,6];
        selectDataA  =[7,8,9];
        selectDataF  =[10,11,12];        
        selectDataPe =[13];  
        selectDataKe =[14];  
        selectDataM  =[15];   
        
    end
    
    properties (Access = private)
        
  
        
    end
    
    methods
        function this = simulate(assembly,model,t,dt,domain)            
            
            this.model = model;
            this.t = t;
            this.dt = dt;
            
            this.dynamics = assembly.dynamics;
            this.dim =  assembly.dim;
            this.data = assembly.data;
            this.K = assembly.K;
            this.dSize =size(this.data);
            this.gamma = zeros(max(this.dSize),1);
            
            if(nargin > 4)
                this.domain = domain;
            end
            
            for dynamic = this.dynamics
                dynamic = char(dynamic); %correction           
                this.Kl(:,:).(dynamic) = logical(this.K.(dynamic));
            end
            
        end  
        
        function run(this)
                
                for i = 1:(this.t/this.dt)

                    for d = 1:this.dim                                           
                        for dynamic = this.dynamics
                            % Correct cell type to string
                            dynamic = char(dynamic); 
                            K = this.K.(dynamic);
                            DATA = this.data(:,this.selectData(d,:),i);
                            GAMMA = z(;
                            SIZE =this.dSize;
                                                    
                            %Potential Energy
                            this.data(:,this.selectDataPe,i) = sum(this.model.(dynamic).Pe(DATA,GAMMA,SIZE,K))' ;
                            
                            %Acceleration
                            this.data(:,this.selectDataA(d),i) = sum(this.model.(dynamic).A(DATA,GAMMA,SIZE,K))' + this.data(:,this.selectDataA(d),i)  ;

                        end
                        
                        %Position
                        this.data(:,this.selectDataX(d),i+1) = 0.5*this.data(:,this.selectDataA(d),i)*this.dt^2 + this.data(:,this.selectDataV(d),i)*this.dt + this.data(:,this.selectDataX(d),i);                           
                        
                        %Velocity
                        this.data(:,this.selectDataV(d),i+1) =  (this.data(:,this.selectDataX(d),i+1) -this.data(:,this.selectDataX(d),i))/(this.dt);
                        
                        
                        if( max(this.data(:,this.selectDataX(d),i+1)) > this.domain(d) || min(this.data(:,this.selectDataX(d),i+1)) <0 )
                            
                            for n = 1:this.dSize
                                
                                cond = (-2*(this.data(n,this.selectDataX(d),i+1) > this.domain(d) || this.data(n,this.selectDataX(d),i+1) <0) + 1) ;
                                this.gamma(i) = cond;
                                
                            end
                                                        
                        end
                                                
                    end
                 
                end
        end

        
        function visulize(this)
            %// Sample x and y values assumed for demo.
            x = this.data(:,this.selectDataX(1),:);
            y = this.data(:,this.selectDataX(2),:);
            z = this.data(:,this.selectDataX(3),:);
             
            s = this.dSize(1);
            cc=hsv(s);
            
            if(this.dim ==2)

                %// Plot point by point
                for k = 1:(this.t/this.dt)

                    subplot(1,2,1);
                    plot(x(:,k),y(:,k),'ro','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',20); %// Choose your own marker here
                    axis([0,this.domain(1),0,this.domain(2)]);
                    hold on

                    j = 1;
                    for dynamic = this.dynamics
                        dynamic = char(dynamic); %correction

                        link = find(triu(this.Kl.(dynamic)));

                        for i = 1:size(link,1)
                            inx = link(i);
                            pointA = mod(inx,s);
                            pointB = 1+(inx - pointA)/s;
                            segX(i,:) = [x(pointA,k),x(pointB,k)];
                            segY(i,:) = [y(pointA,k),y(pointB,k)];
                        end

                        plot(segX',segY',':','LineWidth',2,'color',cc(j,:));
                        
                        j+1;
                    end


                     F(k) = getframe;
                     clf; 
                end

            
            end
                      
            fps = floor(1/this.dt);
            movie(F,1,fps);
        end
        
    end

end

