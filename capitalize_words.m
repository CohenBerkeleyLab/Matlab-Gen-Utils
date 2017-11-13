function [ str ] = capitalize_words( str )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Adapted from https://www.mathworks.com/matlabcentral/answers/107307-function-to-capitalize-first-letter-in-each-word-in-string-but-forces-all-other-letters-to-be-lowerc

% Find all instances of a non-whitespace character preceeded by whitespace.
% Pad the beginning of the string with a space to include the first word,
% then decrement the indices returned to adjust for that.
idx = regexp([' ' str],'(?<=\s+)\S','start')-1;
str(idx) = upper(str(idx));

end

