clc
clear

mesh = feaDesc(2,'x*exp(-1*(y-1)^2)','2*x*exp(-1*(y-1)^2)*(2*y^2-4*y+1)')
quadMesh = mesh.quad
quadAssembly = assembler(quadMesh)

quadAssembly = quadAssembly.addDR(1)
quadAssembly = quadAssembly.addDR(2)
%quadAssembly = quadAssembly.addDR(3)
quadAssembly = quadAssembly.addDR(4)


full(quadAssembly.A)
quadAssembly.b