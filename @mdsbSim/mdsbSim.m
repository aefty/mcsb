classdef mdsbSim < handle
    %SIMULATE Summary of this class goes here
    %   Detailed explanation goes here
    properties (Access  = public)
        domain;
        t;
        dt;
    end

    properties (SetAccess  = protected)
        dynamics;
        model;
        K;
        Kl;

        data;
        ic;
        dim;
        data_size;
    end

    properties (Access = public)
        select;
    end

    methods (Access = public)
        function this = mdsbSim(assembly,t,dt)

            this.t = t;
            this.dt = dt;

            this.dynamics = assembly.dynamics;
            this.dim =  assembly.dim;
            this.ic = assembly.data;
            this.K = assembly.K;
            this.data_size =size(this.ic);

            this.domain = assembly.domain;

            for dynamic = this.dynamics
                temp = char(dynamic);
                this.Kl(:,:).(temp) = logical(this.K.(temp));
            end

            this.setSelector();
        end % mdsbSim

        function run(this)
            itr = floor(this.t/this.dt);
            INFO = struct(...
                'domain',this.domain, ...
                'dim',this.dim,...
                'time',this.t,...
                'dt',this.dt,...
                'size',this.data_size,...
                'select',this.select...
                );

            this.data = zeros([size(this.ic),itr]);
            this.data(:,:,1) = this.ic;

            unitary = ones(1,this.data_size(1));

            for i = 2:itr
                disp(sprintf('Progress: %.0f%%',100*i/itr));
                this.data(:,this.select.data.m,i) = this.data(:,this.select.data.m,i-1);

                r = zeros(this.data_size(1) ,this.data_size(1) ,this.dim );
                r_theta = zeros(this.data_size(1) ,this.data_size(1) ,this.dim );
                r_norm = zeros(this.data_size(1));
                I = eye(this.data_size(1));

                position = this.data(:,this.select.data.x,i-1);

                for d = 1:this.dim
                    r(:,:,d) =  (position(:,d) * unitary)'  -  (position(:,d) * unitary);
                    r_norm = r_norm + r(:,:,d).^2;
                end

                r_norm = r_norm+I;
                r_norm = r_norm.^0.5;

                for d = 1:this.dim
                    r_theta(:,:,d) = r(:,:,d)./r_norm;
                end

                for j = 1:max(size(this.dynamics))

                    dynamic_name  = char(this.dynamics(j));

                    %Work Variables
                    DATA = this.data(:,:,i-1);
                    REL = struct('r',r,'r_norm',r_norm,'r_theta',r_theta);
                    INFO.clock = this.dt*i;
                    K = this.K.(dynamic_name);

                    %Calculate Dynamic
                    [E,A] = feval(dynamic_name,DATA,REL,K,INFO);

                    %Assigns Dynamic Potential Energy (N x 1)
                    this.data(:,this.select.data.pe,i) = E + this.data(:,this.select.data.pe,i);

                    %Assign Dynamic Force & Acceleration (N x 3)
                    this.data(:,this.select.data.a,i) = A + this.data(:,this.select.data.a,i);
                end

                %Position
                this.data(:,this.select.data.x,i) = 0.5.*this.data(:,this.select.data.a,i).*(this.dt^2) + this.data(:,this.select.data.v,i-1).*this.dt + this.data(:,this.select.data.x,i-1);

                %Velocity
                this.data(:,this.select.data.v,i) = (this.data(:,this.select.data.x,i) - this.data(:,this.select.data.x,i-1) )./this.dt;

                %Kinetic Energy
                this.data(:,this.select.data.ke,i) = 0.5.*this.data(:,this.select.data.m,i).*sum(this.data(:,this.select.data.v,i).^2,2);

            end
        end % run

        function plot(this)

            if(this.dim ==2)
                this.plot_2d;
            end

        end %plot
    end %method

    methods (Access = private)
        function setSelector(this)
            this.select.data.dim=[1,4,7,10,11,12;
                                  2,5,8,10,11,12;
                                  3,6,9,10,11,12];

            this.select.data.x  = [1,2,3];
            this.select.data.v  = [4,5,6];
            this.select.data.a  = [7,8,9];
            this.select.data.pe = [10];
            this.select.data.ke = [11];
            this.select.data.m  = [12];
            this.select.data.r  = [13];
        end %setSelector

        function plot_2d(this)
            x = this.data(:,this.select.data.x(1),:);
            y = this.data(:,this.select.data.x(2),:);
            scrsz = get(groot,'ScreenSize');

            pe = sum(this.data(:,this.select.data.pe,:));
            ke = sum(this.data(:,this.select.data.ke,:));

            pe = reshape(pe,[],size(pe,3));
            ke = reshape(ke,[],size(ke,3));
            te = pe+ke;

            max_pe = max(pe);
            max_ke = max(ke);
            max_e = max(max_pe,max_ke);

            s = this.data_size(1);
            cc=hsv(s);

            itr = this.t/this.dt;

            figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
            plot((1:itr),[pe',ke',te']);
            grid on
            grid minor
            legend('Potential Energy','Kinetic Energy','Total Energy');

            figure('Position',[scrsz(3)/2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
            for k = 1:itr
                disp(sprintf('Progress: %.0f%% - %d',100*k/itr,k));

                plot(...
                    x(:,k),...
                    y(:,k),...
                    'ro','MarkerFaceColor','w','MarkerEdgeColor','k','MarkerSize',20);
                grid on
                grid minor

                xlim(this.domain.range(1,:));
                ylim(this.domain.range(2,:));

                drawnow
            end
        end %plot_2d
    end%method
end %object

