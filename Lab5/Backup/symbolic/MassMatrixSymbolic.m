function I = MassMatrixSymbolic(delta_x,delta_y,delta_z)
%PDEC Summary of this function goes here
%   Detailed explanation goes here

d=3;

xi = sym ('xi', 'real');
eta = sym ('eta', 'real');
zeta = sym ('zeta', 'real');

dx = sym ('dx', 'real');
dy = sym ('dy', 'real');
dz = sym ('dz', 'real');

c = [
    -1,-1,-1;
     1,-1,-1;
     1, 1,-1;
    -1, 1,-1;
    -1,-1, 1;
     1,-1, 1;
     1, 1, 1;
    -1, 1, 1;
    ];

J(1,1) =  0.5*dx;
J(2,2) = 0.5*dy;
J(3,3) = 0.5*dz;

for i = 1:8
    N(i) =  1/2^d*(1+c(i,1)*xi)*(1+c(i,2)*eta)*(1+c(i,3)*zeta);
end


F = det(J)*N'*N;
I = int(int(int(F,'xi',-1,1),'eta',-1,1),'zeta',-1,1);
I = simplify(I);

%If delta_x AND delta_y is given evalute matrix at these points.
if(nargin ==  3)
    I = subs(I,[dx, dy,dz], [delta_x,delta_y,delta_z]);
end

end

