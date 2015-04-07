% Add Zero boundary condtion at 0,0 for Von Neumann
function [K,b] = addBCVNZ(b,K,Points,PointMarker)
i=1;
x_val = Points(i,1); y_val = Points(i,2);
b(i,1)= solutionEq(x_val,y_val);

 % Zero out the BC row of K and set i,i to 1
 K(i,:) = zeros(1,size(Points,1)); K(i,i)=1;  
end
