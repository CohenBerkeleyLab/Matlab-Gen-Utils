function [ v ] = veccat( varargin )
%VECCAT Concatenate vectors along their non-singleton dimension
%   V = VECCAT( V1, V2, ... ) Concatenate the vectors V1, V2, etc. along
%   their long dimension. All inputs must be scalars or the same vector
%   type (i.e. row or column).

E = JLLErrors;


first_is_row = -1;
for a=1:numel(varargin)
    % Checking if inputs are either all row or all column vectors. Cannot
    % just compare to first input, in case first input is scalar.
    if first_is_row < 0
        if isscalar(varargin{a}) || isempty(varargin{a})
            continue
        else
            first_is_row = isrow(varargin{a});
        end
    end
    if isrow(varargin{a}) ~= first_is_row
        E.badinput('All inputs to VECCAT must be the same sort of vector (row or column). This function does not handle mixed vector types')
    elseif ~isvector(varargin{a})
        E.badinput('VECCAT only concatenates vectors')
    end
end

% If all scalars, cat along first dimension
if first_is_row < 0
    catdim = 1;
else
    catdim = first_is_row + 1;
end
v = cat(catdim, varargin{:});

end

