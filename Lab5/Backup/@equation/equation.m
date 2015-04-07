classdef solver
    %EQUATION Summary of this class goes here
    %   Detailed explanation goes here    
    properties
        value;
        data;
        eqString;
    end
    
    methods
        
        % Constructor
        function this = solver(eqString)
            %this.Points = mesh.Points;
            %this.calc=zeros(size(this.Points,1),1);
            this.eqString = eqString;
        end
 
        function this = map(this,data)
            this.value=zeros(size(data,1),1);
            this.data =data;
            
            for i = 1 : size(data,1)
               
                x = data(i,1);
                y = data(i,2);
                z = data(i,3);
                             
                %Equation
                this.value(i,1) = eval(this.eqString);                
            end
        end       
    end
    
end

