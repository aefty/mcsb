% Genearte Local mass matrix for given delta x and y
function Me = makeLocalMassMatrixT(this,delta_x, delta_y)

Me =[  1/6, 1/12, 1/12;
 1/12,  1/6, 1/12;
 1/12, 1/12,  1/6
 ]*(delta_x*delta_y)/2;

end