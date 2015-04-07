% assembleDiscreteOperators (MATRIX, MATRIX, VECTOR)
% Fast assemble FEA system
function [As,Ms, b] = assembleFast(Elements, Points, dx, dy)
    
    nv = size(Elements,2);
    
    if nv==4     
        Me = makeLocalMassMatrix(dx,dy);
        Le = makeLocalLaplacianMatrix(dx,dy);
    elseif nv ==3
        Me = makeLocalMassMatrixT(dx,dy);
        Le = makeLocalLaplacianMatrixT(dx,dy);   
    end
         
    me = Me(:);
    le = Le(:);
    n = size(Points,1);
    
    nel = size(Elements,1);
    
    M = repmat(me, nel, 1);
    L = repmat(le, nel, 1);
    i=1:nv; j=ones(1,nv);
    
    ig = repmat(i,1,nv);
    
    jg = repmat(1:nv,nv,1); jg=jg(:)';
    
    iA = Elements(:,ig)';
    jA = Elements(:,jg)';
    %A = L+M;
    A=L;
    As = sparse(iA(:), jA(:), A, n, n);
    Ms = sparse(iA(:), jA(:), M, n, n);
    b=ones(n,1);
    
    % this is just a vector form of the source function
    %f = arrayfun(makeSource2(),Points(:,1),Points(:,2));
    %f = makeSource2(Points(:,1),Points(:,2));
    f = makeSource(Points);
    I = Elements';
    F = f(I);
    b = Me*F;
    
    I = I(:);
    J = ones(nv*nel, 1);
    
    B = sparse(I, J, b(:), n, 1);

    [I, J, b] = find(B);   
end