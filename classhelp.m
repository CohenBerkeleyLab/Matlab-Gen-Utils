function [  ] = classhelp( class_in, method )
%CLASSHELP Prints help on a class or methods therein
%   The matlab help functions don't seem to handle methods in classes very
%   well. This function will print the help comments from a class and list
%   every method in it. Additionally you can specify a method name for
%   more help on that method. Pass 'allmethods' as the method name to list
%   every non-private method in the class with its help.

E = JLLErrors;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% INPUT CHECKING %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~ischar(class_in)
    E.badinput('Must pass class name as a string')
elseif nargin > 1 && ~ischar(method)
    E.badinput('Must pass a method name as a string')
elseif nargin < 2
    method = 'classonly';
end

C = which(class_in);
if isempty(C)
    fprintf('%s is not on your MATLAB path\n', class_in);
    return
end

end

