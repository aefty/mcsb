% Clear variables
close all;
clear all;
clc;
%End

%nSet = [10, 20, 40, 80, 160, 320];
nSet = [10,20,40];
problemString = '-2*x*exp(-1*(y-1)^2)*(2*y^2-4*y+1)';
solutionString = 'x*exp(-1*(y-1)^2)';

convArrayQ = zeros(size(nSet,2),2);
convArrayT = zeros(size(nSet,2),1);

timeStud = zeros(2,size(nSet,2));

for i = 1: size(nSet,2)
    
    
    n = nSet(1,i)
    
    tStart = tic;
    
    mesh = feaDesc(n,problemString,solutionString);
    
    quadMesh = mesh.quad;
    quadAssembly = feaAsem(quadMesh);

    quadAssembly = quadAssembly.addDR(1);
    quadAssembly = quadAssembly.addDR(2);
    quadAssembly = quadAssembly.addVN(3);
    quadAssembly = quadAssembly.addDR(4);

    
     %quadAssembly = quadAssembly.addTS();

    
    timeStud(1,i) = toc(tStart);
    
    uh = quadAssembly.A \ quadAssembly.b;
    
    timeStud(2,i) = toc (tStart) - timeStud(1,i);
    
    u = quadAssembly.ExactSolution;
    M = quadAssembly.M;
    A = quadAssembly.A;

    [LQ,HQ]= conv(uh,u,M,A);
    
    convArrayQ(i,1) =LQ;
    convArrayQ(i,2) =HQ;
    
    
    %Quad
    fileName = strcat('lab3_quad_',num2str(n),'.vtk');
    writeMeshAsVTKFile(quadMesh.Elements,quadMesh.Points,fileName,uh,9)
end

%Exact solution
fileName = 'lab3_quad_9999.vtk';
writeMeshAsVTKFile(quadMesh.Elements,quadMesh.Points,fileName,u,9)
%End

figure
area(nSet,timeStud')
legend('Assembly Quad', 'Solution(invert)Quad'  )

xlabel('N')
ylabel('Time (Seconds)')
print -depsc2 timeStudQuad.eps


for i = 1: size(nSet,2)
    
    n = nSet(1,i)
    
    tStart = tic;
    
    mesh = feaDesc(n,problemString,solutionString);
    
    triMesh = mesh.tri;
    triAssembly = feaAsem(triMesh);

    triAssembly = triAssembly.addDR(1);
    triAssembly = triAssembly.addDR(2);
    triAssembly = triAssembly.addVN(3);
    triAssembly = triAssembly.addDR(4);

    timeStud(1,i) = toc(tStart);
       
    uh = triAssembly.A \ triAssembly.b;
    
    timeStud(2,i) = toc (tStart) - timeStud(1,i);
    
    u= triAssembly.ExactSolution;
    M = triAssembly.M;
    A = triAssembly.A;
    
    [LT,HT]= conv(uh,u,M,A);
    
    convArrayT(i,1) =LT;
    convArrayT(i,2) =HT;
    
    %Tri
    fileName = strcat('lab3_tri_',num2str(n),'.vtk');
    writeMeshAsVTKFile(triMesh.Elements,triMesh.Points,fileName,uh,5)
end

%Exact solution
fileName = 'lab3_tri_9999.vtk';
writeMeshAsVTKFile(triMesh.Elements,triMesh.Points,fileName,u,5)
%End




figure
area(nSet,timeStud')
legend('Assembly Tri', 'Solution(invert) Tri'  )

xlabel('N')
ylabel('Time (Seconds)')
print -depsc2 timeStudTri.eps




delta = 1./nSet;

figure
loglog(delta,convArrayQ(:,1),'--go')
hold on
loglog(delta,convArrayQ(:,2),':go')

hold on
loglog(delta,convArrayT(:,1),'--ro')
hold on
loglog(delta,convArrayT(:,2),':ro')
hold on

legend('Quad - L Two Norm','Quad - H One Norm','Tri - L Two Norm','Tri - H One Norm')

xlabel('h - Delta_x or Delta_y or 1/N')
ylabel('Norm')
print -depsc2 conv.eps










