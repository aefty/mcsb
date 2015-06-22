clear;
clc;
close all;

N = 5;

space = mdsbSpc(2);
dom = space.dmn([-10, 20], [-10, 10]);

p(1) = space.prtcl(1000);%Set Anchor

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
                1000,%r
                0
                ];

for i = 2 : N
	p(i) = space.prtcl(1);
end

asm = mdsbAsm(p, dom);

for i = 2 : N
	asm.rel('bond', p(i), p(1), 1);
end

t = 100;
dt = .1;

s = mdsbSim(asm, t, dt);

s.run
s.plot