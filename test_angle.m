clear;
clc;
close all;

N = 3;

space = mdsbSpc(2);
dom = space.dmn([-10, 10], [-10, 10]);

for i = 1 : (N-1)*(N-1)
    p(i) = space.prtcl(1);
end

for i = 1 : N-1
    for j = 1 : N-1
        p((N-1)*(i-1)+j).property.ic=[...
                        1*j,...%dx
                        1*i,...%dy
                        0,...%dz
                        0,...%vx
                        0,...%vy
                        0,...%vz
                        0,...%ax
                        0,...%ay
                        0,...%az
                        0,...%ke
                        0,...%pe
                        1,...%m
                        10];%r                         
    end
end

asm = mdsbAsm(p, dom);


asm.rel('bond' , p(1), p(2), .1);
asm.rel('bond' , p(1), p(3), .1);
asm.rel('bond' , p(2), p(4), .1);
asm.rel('bond' , p(4), p(3), .1);

asm.rel('angle', p(1), p(2), 0);
asm.rel('angle', p(2), p(4), 90);
asm.rel('angle', p(4), p(3), 0);
asm.rel('angle', p(3), p(1), 90);



t = 100;
dt = .1;

s = mdsbSim(asm, t, dt);

s.run
s.plot