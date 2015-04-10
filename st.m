clear;
clc;


a = mdsbPrt(2);
b = mdsbPrt(1);

asm = mdsbAsm([a,b]);
asm.addRelation('spring',a,b,2);


t=1;
dt=.1;

sim = mdsbSim(asm,t,dt);






