function funs = makefuns(varargin)

        funs.fun1=@dd;
        %funs.fun2=@ff;        

end


function [a,p] = dd(alpha,beta) 
    disp(alpha);
     
    x=5;
    a=alpha;
    b=beta;
end

function [a,p] = ff(alpha,beta) 
    disp(alpha);
     
    disp(beta);
    x=5;
    disp(x); 
    a=alpha;
    b=beta;
end