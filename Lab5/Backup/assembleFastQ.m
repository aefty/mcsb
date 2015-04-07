% assembleDiscreteOperators (MATRIX, MATRIX, VECTOR)
% Fast assemble FEA system
function [As, b] = assembleFastQ(Elements, Points, dx, dy, nx, ny)
    
    tic
    Me = makeLocalMassMatrix(dx,dy);
    Le = makeLocalLaplacianMatrix(dx,dy);
    
    me = Me(:);
    le = Le(:);
    
    n = size(Points,1);
    nel = size(Elements,1);
    nv = 4;
    
    M = repmat(me, nel, 1);
    L = repmat(le, nel, 1);
    
    i=1:nv; j=ones(1,nv);
    
    ig = repmat(i,1,nv);
    
    jg = repmat(1:nv,nv,1); jg=jg(:)';
    
    iA = Elements(:,ig)';
    
    jA = Elements(:,jg)';
    
    A = (L+M)';
    N = size(A(:),1);
    
    
    As = sparse(iA(:), jA(:), A(:), N, N);
    
    
    b=rand(n,1);
    
    % this is just a vector form of the source function
    [f] = makeSource(Points);
    I = Elements';
    F = f(I);
    b = Me*F;
    
    I = I(:);
    J = one(nv*nel, 1);
    
    B = sparse(I, J, b(:), n, 1);
    
    [I, J, b] = find(B);
    
    elapsed_time = toc;
    fprintf('Time required for %d by %d matrix is %f\n', nx, ny, elapsed_time);
    
end