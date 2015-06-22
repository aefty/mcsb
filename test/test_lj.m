clear;
clc;
close all;

N = 3;

space = mdsbSpc(2);
dom = space.dmn([-10, 20], [-10, 10]);


p(1) = space.prtcl(1);%Set Anchor
p(1).property.ic=[
            0,%dx
                0,%dy
                0,%dz
                0,%vx
                0,%vy
                0,%vz
                0,%ax
                0,%ay
                0,%az
                0,%ke
                0,%pe
                100,%r
                0
                ];

            
for i = 1 : N
    p(i*N+j) = space.prtcl(1);
    p(i*j).property.ic=[
                i,%dx
                j,%dy
                0,%dz
                0,%vx
                0,%vy
                0,%vz
                0,%ax
                0,%ay
                0,%az
                0,%ke
                0,%pe
                1,%r
                0
                ];
end

%Assemble Objects
asm = mdsbAsm(p, dom);

for i = 1 : N
    for j = 1 : N
        asm.rel('lj', p(i*j), p(i*j), .2);
    end
end


t = 100;
dt = .1;

s = mdsbSim(asm, t, dt);

s.run
s.plot