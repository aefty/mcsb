clear;
clc;
close all;

N = 50;

space = mdsbSpc(2);
dom = space.dmn([-10, 10], [-10, 10]);

p(1) = space.prtcl(1,20);%Set Anchor

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
               100,%m
               20 %r
               ];

for i = 2 : N
   p(i) = space.prtcl(1);
end

asm = mdsbAsm(p, dom);

for i = 2 : N
	asm.rel('bond', p(i), p(1), 3);
end

t = 200;
dt = .01;

s = mdsbSim(asm, t, dt,10);

s.run
s.plot