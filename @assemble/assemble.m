classdef assemble < handle
    %SIMULATE Summary of this class goes here
    %   Detailed explanation goes here
    properties
        particals;
        K;
        M;
        particalList;
        dynamics;
        dim;
        data;
    end
    
    methods
        function this = assemble(particals) 
            
            s = max(size(particals));
            this.particals = particals;
            
            this.M = zeros(s,1);
            
            i =1;
            for partical = particals
                this.dim = partical.dim;
                
                this.M(i,1) = partical.data(end);
                
                this.data(i,:) = partical.data;
                
                this.particalList{i} = partical.id;
                i =i +1;
            end
        end  
        
        
        function this = addRelation(this,from,dynamic,to,k)
            
            if(~isfield(this.K,dynamic))
                this.K.(dynamic) = zeros(max(size(this.particalList)));
            end
            
            a_id = from.id;
            b_id = to.id;
            
            row = find(ismember(this.particalList,a_id));
            col = find(ismember(this.particalList,b_id));
            
            this.K.(dynamic)(row,col)=this.K.(dynamic)(row,col)+k;
            this.K.(dynamic)(col,row)=this.K.(dynamic)(col,row)+k;
            
            this.dynamics{end+1}=dynamic;
            this.dynamics = unique(this.dynamics);
        end
        
        
    end
    
end

