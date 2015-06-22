clear;
clc;
close all;

N = 2;

space = mdsbSpc(2);
dom = space.dmn([-10, 10], [-10, 10]);

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

for i = 2 : N
	p(i) = space.prtcl(1,1);
end

set = mdsbAsm(p, dom);

set.rel('shell', p(1),.5);

for i = 2 : N
   % set.rel('spring', p(i), p(1), 10);
    set.rel('shell', p(i),.5);
end




t = 2;
dt = .01;

s = mdsbSim(set, t, dt);

s.run
s.plot