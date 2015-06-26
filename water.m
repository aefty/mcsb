clear;
clc;
close all;

N = 10;

space = mdsbSpc(2);
dom = space.dmn([0, 10], [0, 10]);


            
for i = 1 : (N-1)*(N-1)
    p(i) = space.prtcl(1);
end

for i = 1 : N-1
    for j = 1 : N-1
        p((N-1)*(i-1)+j).property.ic=[...
                        5+j/2,...%dx
                        5+i/2,...%dy
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

% Anchor
p(end+1) = space.prtcl(100000);
p(end).property.ic=[...
                        5,...%dx
                        5,...%dy
                        0,...%dz
                        0,...%vx
                        0,...%vy
                        0,...%vz
                        0,...%ax
                        0,...%ay
                        0,...%az
                        0,...%ke
                        0,...%pe
                        100000,...%m
                        10];%r    


%Assemble Objects
asm = mdsbAsm(p, dom);

for i = 2 : (N-1)*(N-1)
    for j = 2 : (N-1)*(N-1)
        asm.rel('lj', p(i), p(j), .1);
    end
    
    asm.rel('bond', p(end), p(i), 1);    
end


for i = 1 :3: ((N-1)*(N-1))
    asm.rel('bond', p(i), p(i+1), 10000);
    asm.rel('bond', p(i), p(i+2), 10000);

    %asm.rel('angle', p(i), p(i+1), 45);
    %asm.rel('angle', p(i), p(i+2), -45);

end

t = 10;
dt = .001;

s = mdsbSim(asm, t, dt,0.1);

s.run
s.plot