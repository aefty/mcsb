clear;
clc;
close all;

N = 12;

space = mdsbSpc(2);
dom = space.dmn([0, 10], [0, 10]);


            
for i = 1 : (N-1)*(N-1)
    p(i) = space.prtcl(1);
end

for i = 1 : N-1
    for j = 1 : N-1
        p((N-1)*(i-1)+j).property.ic=[...
                        4+j/4,...%dx
                        4+i/4,...%dy
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


%Assemble Objects
asm = mdsbAsm(p, dom);

for i = 2 : (N-1)*(N-1)
    for j = 2 : (N-1)*(N-1)
        asm.rel('lj', p(i), p(j), .1);
    end
end


t = 10;
dt = .01;

s = mdsbSim(asm, t, dt);

s.run
s.plot