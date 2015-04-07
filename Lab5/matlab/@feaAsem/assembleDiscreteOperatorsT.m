% assembleDiscreteOperatorsT (MATRIX, MATRIX, VECTOR)
% Assemble FEA system
function [M , K , b] = assembleDiscreteOperatorsT(Points, Elements, PointMarker)
n = size(Points, 1 ) ;
nel = size(Elements, 1 );
M = sparse(n , n) ; K = sparse(n , n) ;
b = zeros(n , 1 ) ;

% Find delta x and delta_y
delta_x = 1/ (n^0.5-1);
delta_y = delta_x;
flip = -1;
%

for e= 1:nel
    
    %The bottom half of the Element matrix is for the top triangles, so
    %filp when half point is reached
    if(e>nel/2)
        flip = 1;
    end
    
    Me = makeLocalMassMatrixT(delta_x, delta_y) ;
    Ke = makeLocalLaplacianMatrixT(delta_x, delta_y,flip);
    fe = makeLocalRhs(e,Points, Elements, Me);
    
    for i= 1: size(Elements,2)
        I = Elements(e , i) ;
        for j= 1: size(Elements,2)
            J = Elements(e,j);
            M(I , J) = M(I , J) + Me(i , j) ;
            K(I , J) = K(I , J) + Ke(i , j) ;
        end % j loo
        
        b(I) = b(I) + fe(i) ;
    end % i loop
end % e loop

end