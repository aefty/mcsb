classdef feaDesc
    % Property data is private to the class
    properties
        n;
        Points;
        Elements;
        PointMarker;
        ProblemString;
        SolutionString;
        Problem;
        dx;
        dy;
    end % properties
    
    methods
        %Constructor
        function this = feaDesc(gridSize,ProblemString,SolutionString)
            this.n = gridSize;
            this.dx = 1/gridSize;
            this.dy = 1/gridSize;
            this.ProblemString = ProblemString;
            this.SolutionString = SolutionString;
        end
        
        %Quad Grid
        function this = quad(this)
            m=this.n;
            n=this.n;
            delta_x =this.dx;
            delta_y =this.dy;
            Elements = zeros(n*m,4);
            Points = zeros((n+1)*(m+1),3);
            PointMarker = zeros((n+1)*(m+1),1);
            j = 0;i = 0;
            
            for row = 1:(n+1)
                for col = 1:(m+1)
                    if(row<=n && col<=m)
                        j=j+1;
                        Elements(j,:) = [
                            (row-1)*(m+1)+(col-1),
                            (row-1)*(m+1)+(col-1)+1,
                            (row-0)*(m+1)+(col-1)+1,
                            (row-0)*(m+1)+(col-1),
                            ];
                    end
                    
                    i=i+1;
                    Points(i,:) = [(col-1)+(col-1)*(delta_x-1),(row-1)+(row-1)*(delta_y-1),0];
                    
                    %Find edge points of grid
                    if(Points(i,2)==0)
                        
                        PointMarker(i,1) = 1;
                        
                    elseif (Points(i,1)==1)
                        
                        PointMarker(i,1) = 2;
                        
                    elseif (Points(i,2)==1)
                        
                        PointMarker(i,1) = 3;
                        
                    elseif (Points(i,1)==0)
                        
                        PointMarker(i,1) = 4;
                    end
                    
                end
            end
            
            %Matlab is base 1
            Elements=Elements+1;
            this.Points=Points;
            this.Elements=Elements;
            this.PointMarker=PointMarker;
            this = this.descProblem();
        end
        
        %Tri Grid
        function this = tri(this)
            this = this.quad();
            
            QPoints=this.Points;
            QElements=this.Elements;
            QPointMarker=this.PointMarker;
            
            
            elSize = size(QElements,1)*2;
            Elements  = ones(elSize,3);
            
            for i = 1 : size(QElements,1)
                Elements(i,:) = [QElements(i,1),QElements(i,2),QElements(i,3)];
                Elements(elSize-i+1,:)=[QElements(i,3),QElements(i,4),QElements(i,1)];
            end
            
            this.Elements=Elements;
            this = this.descProblem();
        end
        
        %Descrtize Problem
        function this = descProblem(this)
            this.Problem=zeros(size(this.Points,1),1);
            this.Problem = this.Problem;
            
            for i = 1 : size(this.Points,1)
                
                x = this.Points(i,1);
                y = this.Points(i,2);
                z = this.Points(i,3);
                
                %Equation
                this.Problem(i,1) = eval(this.ProblemString);
            end
        end
        
    end  % methods
end % class