classdef mdsbPrt < handle
    % Property data is private to the class
    properties (Access  = 'public')
        color = 'bk';
        name='Default_name';
        ic;
    end % properties
    
    properties (SetAccess = 'protected')
        dim=2;
        id;
    end % properties    
    
    methods
        %Constructor
        function this = mdsbPrt(mass,dim,color,name)
            
            if(nargin > 1)
                this.dim = dim;
            end
            
            if(nargin > 2)
                this.color = color;
            end
                        
            if(nargin > 3)
                this.name = name;
            end
            

            % [dx,dy,dz,vx,vy,vx,ax,ay,az,fx,fy,fz,ke,pe,m]
            this.ic= [
                rand(1,1)*5,%1dx
                rand(1,1)*5,%2dy
                rand(1,1)*5,%3dz
                rand(1,1)*5,%4vx
                rand(1,1)*5,%5vy
                rand(1,1)*5,%6vz
                0,%7ax
                0,%8ay
                0,%9az
                0,%10fx
                0,%11fy
                0,%12fz                
                0,%13ke 
                0,%14pe                 
                mass];%15m
            
            if(this.dim ==2)
                this.ic = this.ic .*[
                1,%dx
                1,%dy
                0,%dz
                1,%vx
                1,%vy
                0,%vz
                1,%ax
                1,%ay
                0,%az
                1,%fx
                1,%fy
                0,%fz                
                0,%ke 
                0,%pe                 
                1];%m
            end
            
            if(this.dim ==1)
                this.ic = this.ic .*[
                1,%dx
                0,%dy
                0,%dz
                1,%vx
                0,%vy
                0,%vz
                1,%ax
                0,%ay
                0,%az
                1,%fx
                0,%fy
                0,%fz                
                0,%ke 
                0,%pe                 
                1];%m
            end
                
            this.id = char(java.util.UUID.randomUUID);
        end  
    end  % methods
end % class