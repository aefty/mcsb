%Genearte local Laplacian
function Le=makeLocalLaplacianMatridxQ(this,dx,dy)
this.Le=[
(dx^2+dy^2)/(3*dx*dy),dx/(6*dy)-dy/(3*dx),-(dx^2+dy^2)/(6*dx*dy),dy/(6*dx)-dx/(3*dy);
dx/(6*dy)-dy/(3*dx),(dx^2+dy^2)/(3*dx*dy),dy/(6*dx)-dx/(3*dy),-(dx^2+dy^2)/(6*dx*dy);
-(dx^2+dy^2)/(6*dx*dy),dy/(6*dx)-dx/(3*dy),(dx^2+dy^2)/(3*dx*dy),dx/(6*dy)-dy/(3*dx);
dy/(6*dx)-dx/(3*dy),-(dx^2+dy^2)/(6*dx*dy),dx/(6*dy)-dy/(3*dx),(dx^2+dy^2)/(3*dx*dy)
];
end