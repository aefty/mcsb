clear;
clc;
close all;

N = 2;

space = mdsbSpc(2);
dom = space.dmn([-10, 20], [-10, 10]);

p(1) = space.prtcl(10000);%Set Anchor
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

%Create objects
p(2) = space.prtcl(1);
p(2).property.ic=[
                1,%dx
                1,%dy
                1,%dz
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

p(3) = space.prtcl(1);
p(3).property.ic=[
                -1,%dx
                -1,%dy
                -1,%dz
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

%Assemble Objects
asm = mdsbAsm(p, dom);

%Anchor to 1

%Create relations
asm.rel('lj_1', p(1), p(3), 1.2);
asm.rel('lj_1', p(1), p(2), 1.2);
asm.rel('lj_1', p(2), p(3), 1.2);

t = 10;
dt = .01;

s = mdsbSim(asm, t, dt);

s.run
s.plot