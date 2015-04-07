%writeMeshAsVTKFile  (VEC, VEC , STR, {VEC-VERTICAL}, {INT})
%make file (.vtk) in home directors /vtkFiles 
%NOTE : file extension spesificed within fileName
function writeMeshAsVTKFile(Elements,Points,fileName,solution,cellType); 

% Convert to base 0
Elements=Elements-1;

% Argument checks and set defaults
if(nargin < 5)
    error('Missing Param')
end

if(solution ==-1)
    solution = (1:1:size(Elements,1))';
end

if(cellType == -1)
    cellType = 9;
end
% End


% VTK filename & saved file enviroment check
if ispc
    desktop = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
else
    desktop = getenv('HOME');
end

if(exist(strcat(desktop,'/vtkFiles/'),'dir') == 0)
    mkdir(desktop,'vtkFiles');
end
    
name = fileName;
fileName = strcat(desktop,'/vtkFiles/',fileName);
% End

% Write file - Points
fid = fopen(fileName,'w+');
fprintf(fid,'# vtk DataFile Version 4.2\n');
fprintf(fid,'%s\n',name);
fprintf(fid,'ASCII\n');
fprintf(fid,'DATASET UNSTRUCTURED_GRID\n');
fprintf(fid,'POINTS %d float\n',size(Points,1));
fprintf(fid,formatStr(Points),Points');
%End

%Write file - Elements
adder = size(Elements,2)*ones(size(Elements,1),1); % Geneate the 'adder' vector which counts the number of vertexes per element
elementExtend = cat(2,adder,Elements); % Concatenate the two adder vector and Element matrix
fprintf(fid,'CELLS %d %d\n',size(elementExtend,1), size(elementExtend,1)*size(elementExtend,2));
fprintf(fid,formatStr(elementExtend) ,elementExtend');
%End

%Write File - Element/Cell Types
cellTypeArray = cellType*ones(size(Elements,1),1);
fprintf(fid,'CELL_TYPES %d\n', size(Elements,1));
fprintf(fid,formatStr(cellTypeArray) ,cellTypeArray');
%End

%Write File - Data
fprintf(fid,'POINT_DATA %d\n', size(Points,1));
fprintf(fid,'SCALARS data float 1\n');
fprintf(fid,'LOOKUP_TABLE default\n');
fprintf(fid,formatStr(solution),solution');
%End

fclose('all');
%End

disp('file ouput:');
disp(fileName); %Write file path for info

%END

    %formatStr (VEC)
    %Return format string for fprintf formating used to convert matrix into string
    function  s = formatStr(vector)      
        s  = strcat( repmat('%d ',1,size(vector,2)),' \n');
    end
end
%END





