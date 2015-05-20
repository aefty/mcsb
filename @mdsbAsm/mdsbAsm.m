classdef mdsbAsm < handle
    %SIMULATE Summary of this class goes here
    %   Detailed explanation goes here

    properties (SetAccess = protected)
        particals;
        particalList;
        domain;

        K;
        M;
        data;

        dynamics;
        dynamics_location;

        dim;
    end

    methods

        function this = mdsbAsm(particals,domain)

            this.particals = particals;

            s = max(size(particals));
            this.dim = this.particals(1).dim;

            for partical = particals

                if(this.dim ~= partical.dim && partical.type == 'particle')
                  disp(partical);
                  error('Dimension mismatch');
                end

                this.M(end+1,1) = partical.property.ic(end);
                this.data(end+1,:) = partical.property.ic;
                this.particalList{end+1} = partical.id;
            end

            if(this.dim ~= domain.dim && domain.type =='domain')
                disp(partical);
                error('Dimension mismatch');
            end

            this.domain = domain.property;
        end

        %                   this,dynamic,from,{to,K}
        function this = rel(this,dynamic,from,varargin)

            %Self-binding, No Constant
            if(nargin == 3)
                to = from;
                K = 0.5*1;
            end

            %Self-binding, With Constant
            if(nargin == 4)
                to = from;
                K =0.5*varargin{1};
            end

            %External-binding, With Constant
            if(nargin == 5)
                to = varargin{1};
                K = varargin{2};
            end

            if(~isfield(this.K,dynamic))
                this.K.(dynamic) = zeros(max(size(this.particalList)));
            end

            a_id = from.id;
            b_id = to.id;

            row = find(ismember(this.particalList,a_id));
            col = find(ismember(this.particalList,b_id));

            this.K.(dynamic)(row,col)=this.K.(dynamic)(row,col)+K;
            this.K.(dynamic)(col,row)=this.K.(dynamic)(col,row)+K;

            this.dynamics{end+1}=dynamic;
            this.dynamics = unique(this.dynamics);
        end

        function this = order(this,cmd)

            if(cmd == 'grid')
                num  = max(size(this.particals));


                for partical = this.particals




                end
            end
        end

    end
end

