% addBC (MATRIX, MATRIX, MATRIX,VECTOR)
% Add boundary condtion to the current system
function [K,b] = addBC(b,K,Points,PointMarker)

    
    % Loop over PointMarker and return its index
    for i = 1:size(PointMarker,1)
        
        %check Pointmarker value if its 1 than we are at endge
        if(PointMarker(i,1)==1)
            
            % Calculate the boudnary condtions
            x_val = Points(i,1);
            y_val = Points(i,2);
            b(i,1)= solutionEq(x_val,y_val);
            
            %Get the column of the K matrix but set the i,i value to 0
            kCol = K(:,i);
            kCol(i,1) = 0;
            
            % Move BC to the rhs and calculate new value
            b = b-b(i,1)*kCol;

            % Zero out the BC row of K and set i,i to 1
            K(i,:) = zeros(1,size(Points,1));
            K(:,i) = zeros(size(Points,1),1);
            K(i,i)=1;       
        end

        
        
    end 
end
