function [ data ] = scale_to_range( data, varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin == 2
    if ~isnumeric(varargin{1}) || numel(varargin{1}) ~= 2
        E.badinput('In the two input form, RANGE must be a 2-element numeric vector');
    end
    minval = varargin{1}(1);
    maxval = varargin{1}(2);
elseif nargin == 3
    minval = varargin{1};
    maxval = varargin{2};
    if ~isnumeric(minval) || ~isscalar(minval)
        E.badinput('In the three input form, MINVAL must be a scalar number')
    end
    if ~isnumeric(maxval) || ~isscalar(maxval)
        E.badinput('In the three input form, MAXVAL must be a scalar number')
    end
end

data = data - min(data(:));
data = data .* (maxval-minval)/max(data(:));
data = data + minval;

end

