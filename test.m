close;
clear;
clc;

n=10

for i = 1:n
    
   pList(i) = partical(1); 
   
   

   
%    pList(i).data = [ ...
%                 i,...%dx
%                 0,...%dy
%                 0,...%dz
%                 0,...%vx
%                 0,...%vy
%                 0,...%vz
%                 0,...%ax
%                 0,...%ay
%                 0,...%az
%                 0,...%fx
%                 0,...%fy
%                 0,...%fz                
%                 0,...%ke 
%                 0,...%pe                 
%                 1];...%m
    
end
    
ass = assemble(pList);



% for i = 2:n
%     
%     %a = mod(floor(rand(1)*10),n)+1;
%     %b = mod(floor(rand(1)*10),n)+1;
%     
%    ass.addRelation(pList(i),'spring',1,pList(i-1));
%    ass.addRelation(pList(i),'rep',1,pList(i-1));   
%     
% end

 ass.addRelation(pList(1),'spring',pList(2),1);


   
loadModel;

sim = simulate(ass,model,20,.03);

sim.run;
sim.visulize;




