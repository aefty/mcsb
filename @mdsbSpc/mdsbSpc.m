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
                error('Space Dimension must be 1,2 or 3');
            end

            this.dim = dim;
        end
        %                     this,mass,{r,color,name}
        function this = prtcl(this,mass,varargin)

            if(nargin ==2)
                r = 10;
                color ='bk';
                name = 'default_name';
            elseif (nargin ==3)
                r = varargin{1};
                color ='bk';
                name = 'default_name';
            elseif (nargin ==4)
                r = varargin{1};
                color =varargin{2};
                name = 'default_name';
            else
                r = varargin{1};
                color =varargin{2};
                name = varargin{3};
            end

            this.property.color = color;
            this.property.name = name;
            this.property.r = r;

            % [dx,dy,dz,vx,vy,vx,ax,ay,az,ke,pe,m,r]
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
                0,%10ke
                0,%11pe
                mass,%12m
                r%13r
                ];

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
                1,%12m
                1%13r
                ];
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
                1,%12m
                1%13r
                ];
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

            this.property.range =domain;

            this.id = char(java.util.UUID.randomUUID);
            this.type = 'domain';
        end
    end  % methods
end % class