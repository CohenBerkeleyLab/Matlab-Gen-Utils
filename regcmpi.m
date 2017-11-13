function [ b ] = regcmpi( str, expression, varargin )
%REGCMP Compares a string against a regular expression
%   B = REGCMP( STR, EXPRESSION, ... ) Will compare STR against the case
%   insensitive regular expression EXPRESSION and return B = true if a
%   match is found.

b = isempty(regexpi(str, expression, varargin{:}, 'once'));

end

