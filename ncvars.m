function [  ] = ncvars( nci, pattern )
%NCVARS( NCI ) Prints out variables in the specified NETCDF file
%   NCVARS( NCI ) will print out a list of the variables in the NETCDF file
%   specified by NCI, with the format:
%       Index: Name: Dimensions
%   NCI must be either a structure returned from ncinfo() or a path to a
%   NETCDF file.
%
%   NCVARS( NCI, PATTERN ) will only display variables matching the regex
%   PATTERN. Matches will be case-insensitive.

if ~isstruct(nci) && ischar(nci) && exist(nci,'file')
    nci = ncinfo(nci);
elseif ~isstruct(nci)
    error('ncvars:bad_input','NCI must be a structure returned from NCINFO or a path to a NETCDF file')
end

if ~exist('pattern','var')
    pattern = '';
elseif ~ischar(pattern)
    E.badinput('PATTERN must be a string')
end

for a=1:numel(nci.Variables)
    if ~isempty(pattern)
        if isempty(regexpi(nci.Variables(a).Name, pattern,'once'))
            continue
        end
    end
    if ~isempty(nci.Variables(a).Dimensions)
        dims = {nci.Variables(a).Dimensions.Name};
        lens = [nci.Variables(a).Dimensions.Length];
    dimstr = '';
    for b=1:numel(lens)
        dimstr = [dimstr, sprintf('%s (%d)',dims{b},lens(b))];
        if b<numel(lens)
            dimstr = [dimstr, ' x '];
        end
    end
    else
        dimstr = 'No dimensions';
    end
    space = repmat(' ',1,20-length(nci.Variables(a).Name));
    fprintf('\t%02d: %s:%s%s\n', a, nci.Variables(a).Name, space, dimstr);
end

end

