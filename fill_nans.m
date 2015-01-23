function [ x,y ] = fill_nans( x,y,varargin )
%fill_nans(x,y): Fills nans in 'y' unless they are at the end of the
%series, then they are removed
%   Linearly interpolates NaNs in 'y' that have non-NaN values around them.
%    NaNs at the beginning or end of 'y' are removed along with their
%    corresponding 'x' value.
%
%   If you wish to override the default behavior so that this function only
%   interpolates interior nans and leaves leading or trailing ones present,
%   pass 'noclip' as the optional third parameter

E = JLLErrors;

narginchk(2,3);
if nargin > 2 && strcmpi(varargin{1},'noclip')
    clipping_bool = false;
else
    clipping_bool = true;
end

if all(isnan(y))
    error(E.badinput('''y'' must not be all nans.'));
end

% Trim leading or trailing NaNs
if clipping_bool
    if isnan(y(1))
        first_val = find(~isnan(y),1,'first');
        y = y(first_val:end);
        x = x(first_val:end);
    end
    if isnan(y(end))
        last_val = find(~isnan(y),1,'last');
        y = y(1:last_val);
        x = x(1:last_val);
    end
end

nans = isnan(y);
y(nans) = interp1(x(~nans),y(~nans),x(nans));