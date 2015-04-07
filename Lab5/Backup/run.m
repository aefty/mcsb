% Clear variables
close all;
clear all;
clc;
%End

nSet = [20,40];

convArrayQ = zeros(size(nSet,2),2);
convArrayT = zeros(size(nSet,2),1);

timeStud = zeros(2,size(nSet,2));

grid= grid()

for i = 1: size(nSet,2)   
 

    n = nSet(1,i)
    
    tStart = tic;

    [PointsQ,ElementsQ,PointMarkerQ] = makeQuadGrid(n);
    [MQ , KQ , bQ] = assembleDiscreteOperatorsQ(PointsQ, ElementsQ, PointMarkerQ);
    [KeditQ,beditQ] = addBCVNZ(bQ,KQ,PointsQ,PointMarkerQ);
    
    timeStud(1,i) = toc(tStart);
   
    uhQ = KeditQ\beditQ;
    
    timeStud(2,i) = toc (tStart) - timeStud(1,i);

    uQ = exSol(PointsQ);
    [LQ,HQ]= conv(uhQ,uQ,MQ,KQ);
    
    convArrayQ(i,1) =LQ; 
    convArrayQ(i,2) =HQ;
    
    
    %Quad
    fileName = strcat('lab3_quad_',num2str(n),'.vtk');
    writeMeshAsVTKFile(ElementsQ,PointsQ,fileName,uhQ,9)
end

    %Exact solution
    fileName = 'lab3_quad_9999.vtk';
    writeMeshAsVTKFile(ElementsQ,PointsQ,fileName,uQ,9)
    %End
      
figure
area(nSet,timeStud')
legend('Assembly', 'Solution(invert)'  )

xlabel('N')
ylabel('Time (Seconds)')
print -depsc2 timeStud.eps


for i = 1: size(nSet,2)

    n = nSet(1,i)

    [PointsT,ElementsT,PointMarkerT] = makeTriGrid(n);
    [MT , KT , bT] = assembleDiscreteOperatorsT(PointsT, ElementsT, PointMarkerT);
    [KeditT,beditT] = addBCVNZ(bT,KT,PointsT,PointMarkerT);
    
    
    uhT = KeditT\beditT;
    
    uT= exSol(PointsT);
    [LT,HT]= conv(uhT,uT,MT,KT);
    
    convArrayT(i,1) =LT; 
    convArrayT(i,2) =HT; 
        
    %Tri
    fileName = strcat('lab3_tri_',num2str(n),'.vtk');
    writeMeshAsVTKFile(ElementsT,PointsT,fileName,uhT,5)
end

    %Exact solution
    fileName = 'lab3_tri_9999.vtk';
    writeMeshAsVTKFile(ElementsT,PointsT,fileName,uT,5)
    %End

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










