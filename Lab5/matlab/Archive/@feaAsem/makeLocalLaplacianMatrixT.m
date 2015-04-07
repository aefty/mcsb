% Genearte the laplacian for given delta x and y AND based on the top or
% bottom postin of the element
function Le = makeLocalLaplacianMatrixT(dx, dy,flip)

% Bottom Triangle
if flip == -1
    Le = [  
         dy/(2*dx),-dy/(2*dx),0;
        -dy/(2*dx),(dx^2 + dy^2)/(2*dx*dy),-dx/(2*dy);                 
         0,-dx/(2*dy),dx/(2*dy)
         ];    
else
 %Top Triangle
     Le = [  
          dx/(2*dy),0,-dx/(2*dy);
          0,dy/(2*dx),-dy/(2*dx);  
          - dx/(2*dy),-dy/(2*dx),(dx^2 + dy^2)/(2*dx*dy)
         ];
end
end