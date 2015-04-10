function varargout = execin(fullFunctionName, varargin)

%EXECIN  Execute a function or script in different directory.
%   EXECIN(FUNCNAME) will execute function FUNCNAME, which is a string that
%   includes the full path of the function.
%
%   [Y1, Y2, ...] = EXECIN(FUNCNAME, X1, X2, ...) allows input and output
%   arguments that are normally allowed by the function FUNCNAME.
%
%   Example:
%     [s, out] = execin('C:\mywork dir\testfunction.m', x1, x2);

%   VERSIONS:
%     v1.0 - First version
%     v1.1 - added ability to run scripts
%     v1.2 - minor syntax fix
%
% Jiro Doke
% Copyright 2005-2010 The MathWorks, Inc.


[p, n] = fileparts(fullFunctionName);

% use SETAPPDATA instead of assigning to a variable in case the script
% clears all variables.
setappdata(0, 'curDir', pwd);
setappdata(0, 'fullFunctionName', fullFunctionName);

try
  cd(p);
  if nargin > 1 % if there are additional arguments, assume it is a function
    [varargout{1:nargout}] = feval(n, varargin{:});
  else
    if nargout % if there are output arguments, assume it is a function
      [varargout{1:nargout}] = feval(n);
    else % use EVAL in case it is a script
      eval(n)
    end
  end    
  cd(getappdata(0, 'curDir')); rmappdata(0, 'curDir'); rmappdata(0, 'fullFunctionName');
catch ME
  cd(getappdata(0, 'curDir')); rmappdata(0, 'curDir');
  fprintf('%s\n', ME.message);
  fullFunctionName = getappdata(0, 'fullFunctionName'); rmappdata(0, 'fullFunctionName');
  error('execin:ErrorInExecution', 'Could not execute ''%s''', fullFunctionName);
end