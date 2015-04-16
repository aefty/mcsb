classdef mdsbSpc
    % Property data is private to the class

    properties (Access = public)
        property;
    end % properties

    properties (SetAccess = private )
        dim;
    end % properties

    properties (SetAccess = private , Hidden = true)
        type ;
        id;
    end % properties

    methods
        %Constructor
        function this = mdsbSpc(dim);

            if(~(0<dim<4))
                error('Space Dimention must be 1,2 or 3');
            end

            this.dim = dim;
        end

        function this = prtcl(this,mass,varargin)

            if(size(varargin,2)==1)
                color = varargin{1};
                name = 'default_name';
            elseif (size(varargin,2)==2)
                color = varargin{1};
                name = varargin{2};
            else
                color = 'bk';
                name = 'default_name';
            end

            this.property.color = color;
            this.property.name = name;

            % [dx,dy,dz,vx,vy,vx,ax,ay,az,fx,fy,fz,ke,pe,m]
            this.property.ic= [
                (rand(1,1)-rand(1,1))*5,%1dx
                (rand(1,1)-rand(1,1))*5,%2dy
                (rand(1,1)-rand(1,1))*5,%3dz
                (rand(1,1)-rand(1,1))*5,%4vx
                (rand(1,1)-rand(1,1))*5,%5vy
                (rand(1,1)-rand(1,1))*5,%6vz
                0,%7ax
                0,%8ay
                0,%9az
                0,%13ke
                0,%14pe
                mass];%15m

            if(this.dim ==2)
                this.property.ic = this.property.ic .*[
                1,%dx
                1,%dy
                0,%dz
                1,%vx
                1,%vy
                0,%vz
                1,%ax
                1,%ay
                0,%az
                0,%ke
                0,%pe
                1];%m
            end

            if(this.dim ==1)
                this.property.ic = this.property.ic .*[
                1,%dx
                0,%dy
                0,%dz
                1,%vx
                0,%vy
                0,%vz
                1,%ax
                0,%ay
                0,%az
                0,%ke
                0,%pe
                1];%m
            end
              this.id = char(java.util.UUID.randomUUID);
              this.type = 'particle';
        end

        function this = dmn(this,varargin)

            if(nargin ~= (this.dim+1) )
                error(strcat('Domain dimension mismatch (',num2str(this.dim),'D)'));
            end

            domain = zeros(3,2);

            if(nargin > 1)
                domain(1,:) = varargin{1};
            end

            if (nargin > 2)
                domain(2,:) = varargin{2};
            end

            if (nargin > 3)
                domain(3,:) = varargin{3};
            end


            %this.property.range = vec2mat(cell2mat(varargin),2);

            this.property.range =domain;

            this.id = char(java.util.UUID.randomUUID);
            this.type = 'domain';
        end
    end  % methods
end % class