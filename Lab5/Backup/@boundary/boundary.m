classdef boundary
    %BOUNDARY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        solutionString;
        mesh;
        b;
        A;
        Points;
        PointMarker;
        brValue;
        
    end
    
    methods
        
        function this = boundary(assembly,solutionString)       
            this.solutionString = solutionString;
            this.mesh=assembly;

        end
        
        function this = addDrc(this,)
            
            for i = 1:size(this.PointMarker,1)
                %check Pointmarker value if its 1 than we are at endge
                if(this.PointMarker(i,1)==1)
                    this.b(i,1)= this.brValue(i,1);
                    %Get the column of the K matrix but set the i,i value to 0
                    kCol = this.K(:,i);
                    kCol(i,1) = 0;
                    % Move BC to the rhs and calculate new value
                    this.b = this.b-this.b(i,1)*kCol;
                    % Zero out the BC row of K and set i,i to 1
                    this.K(i,:) = zeros(1,size(this.Points,1));
                    this.K(:,i) = zeros(size(this.Points,1),1);
                    this.K(i,i)=1;       
                end
            end
        end
        
        function this = addVnm(this)
            i=1;
            x_val = this.Points(i,1); 
            y_val = this.Points(i,2);
            b(i,1)= brValue(i,1);

            % Zero out the BC row of K and set i,i to 1
            this.K(i,:) = zeros(1,size(this.Points,1)); 
            this.K(i,i)=1;  
        end
        
    end
    
end

