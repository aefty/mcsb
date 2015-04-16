clear;
clc;
close all;

N = 10;

space = mdsbSpc(2);
dom = space.dmn([-10, 10], [-10, 10]);

set(1) = space.prtcl(1000);

set(1).property.ic=[
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
                1000];
for i = 2 : N
	set(i) = space.prtcl(1);
end

asm = mdsbAsm(set, dom);

for i = 2 : N
	asm.rel('spring', set(i), set(i - 1), 100);
end

t = 20;
dt = .001;

s = mdsbSim(asm, t, dt);

s.run
s.plot