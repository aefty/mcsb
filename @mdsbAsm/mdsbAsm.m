classdef mdsbAsm < handle
    %SIMULATE Summary of this class goes here
    %   Detailed explanation goes here
    properties (SetAccess = 'protected')
        particals;
        K;
        M;
        particalList;
        dynamics;
        dynamics_location;
        dim;
        data;
    end
    
    methods
        function this = mdsbAsm(particals) 
            
            this.particals = particals;
            
            s = max(size(particals));
            this.M = zeros(s,1);
            this.dim = this.particals(1).dim;            
            
            i =1;
            for partical = particals
                
                if(this.dim ~= partical.dim)
                  disp(partical);
                  error('Dimention mismatch');
                end
                
                this.M(i,1) = partical.ic(end);
                this.data(i,:) = partical.ic;
                this.particalList{i} = partical.id;
                i =i +1;
            end
        end  
        
        
        function this = addRelation(this,dynamic,from,to,k,varargin)

            if(nargin == 6)
                dynamics_location = varargin{1};
            else
                dynamics_location = strcat(dynamic,'.m');
            end
            
            if(~isfield(this.K,dynamic))
                this.K.(dynamic) = zeros(max(size(this.particalList)));
            end
            
            %If "boundary" dynamic
            
            
            
            
            
            
            a_id = from.id;
            b_id = to.id;
            
            row = find(ismember(this.particalList,a_id));
            col = find(ismember(this.particalList,b_id));
            
            this.K.(dynamic)(row,col)=this.K.(dynamic)(row,col)+k;
            this.K.(dynamic)(col,row)=this.K.(dynamic)(col,row)+k;
            
            this.dynamics{end+1}=strcat(dynamic,'|',dynamics_location);
            this.dynamics = unique(this.dynamics); 
            
        end
        
        
    end
    
end

