function [ b ] = regcmp( str, expression, varargin )
%REGCMP Compares a string against a regular expression
%   B = REGCMP( STR, EXPRESSION, ... ) Will compare STR against the case
%   sensitive regular expression EXPRESSION and return B = true if a match
%   is found.

b = isempty(regexp(str, expression, varargin{:}, 'once'));

end

