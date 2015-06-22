

v1s = sym('v1s','real');
v1f = sym('v1f','real');

v2s = sym('v2s','real');
v2f = sym('v2f','real');

m1 = sym('m1','real');
m2 = sym('m2','real');

Ke = sym('Ke','real');
P = sym('P','real');

eq1=Ke - (m1*v1f^2+m2*v2f^2);
 
eq2 =P + (m1*v1f+m2*v2f);
 
v1f_solve = solve(eq1,v1f)
v2f_solve = solve(subs(eq2, v1f,  v1f),v2f);

v1f = solve(subs(eq1, v2f, v2f_solve),v1f)

a =v1 -(P*m1 + m2*...
    ((m1*(- P^2 + Ke*m1 + Ke*m2))/m2)^(1/2)...
    )/(m1^2 + m2*m1);


