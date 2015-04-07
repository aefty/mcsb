% assembleDiscreteOperators (MATRIX, MATRIX, VECTOR)
% Assemble FEA system
function [M , K , b] = assembleDiscreteOperatorsQ(Points, Elements, PointMarker)
n = size(Points, 1 ) ;
nel = size(Elements, 1 );
M = sparse(n , n) ; K = sparse(n , n) ;
b = zeros(n , 1 ) ;

% Find delta x and delta_y
delta_x = 1/ (n^0.5-1);
delta_y = delta_x;
%

for e= 1:nel
    Me = makeLocalMassMatrix(delta_x, delta_y) ;
    Ke = makeLocalLaplacianMatrix(delta_x, delta_y);
    fe = makeLocalRhs(e,Points, Elements, Me);
    
    for i= 1: size(Elements,2)
        I = Elements(e , i) ;
        for j= 1: size(Elements,2)
            J = Elements(e , j) ;
            M(I , J) = M(I , J) + Me(i , j) ;
            K(I , J) = K(I , J) + Ke(i , j) ;
        end % j loo
        
        b(I) = b(I) + fe(i) ;
    end % i loop
end % e loop

end