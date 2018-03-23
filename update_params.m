function parameters = update_params(parameters,varargin)
%UPDATE_PARAMETERS Update parameter values in a cell array of name-value pairs
%   PARAMETERS = UPDATE_PARAMS(PARAMETERS, NAME1, VALUE1, NAME2, VALUE2,
%   ...) will look for a char array or string matching each NAME in
%   PARAMETERS and replace the following element with the respective VALUE.
%   This is intended for updating "varargin" input arrays that contain
%   name-value pairs that need to be modified before passing to subordinate
%   functions.

E = JLLErrors;

if ~iscell(parameters)
    E.badinput('PARAMETERS must be a cell array')
end

% We're not going to check that parameters has an even number of elements
% or that it alternates name and value because it might include some
% optional but unnamed input values.

if numel(varargin) < 2
    E.badinput('Must provide at least one parameter name-value pair')
elseif mod(numel(varargin),2) ~= 0
    E.badinput('There must be an even number of arguments after the original parameters cell array (alternating parameter name and value)');
end

for i_param = 1:2:numel(varargin)
    this_param = varargin{i_param};
    
    if ~ischar(this_param)
        E.badinput('The first, third, fifth, etc. inputs after the parameters cell must be char arrays or strings (these are the parameter names)')
    end
    
    param_idx = find(strcmp(parameters, this_param));
    if isempty(param_idx)
        E.callError('unknown_parameter', 'The parameter named "%s" does not exist in the parameters cell array', this_param);
    elseif isscalar(param_idx) && mod(param_idx, 2) ~= 1
        E.callError('parameter_name_matched_value', 'The parameter name "%s" only appears as a parameter value', this_param);
    elseif ~isscalar(param_idx)
        % Try removing the even parameter indices; it's possible that the
        % parameter name is supposed to show up as a value
        param_idx(mod(param_idx,2) ~= 1) = [];
        if isempty(param_idx)
            E.callError('parameter_name_matched_value', 'The parameter name "%s" only appears as a parameter value', this_param);
        elseif ~isscalar(param_idx)
            E.callError('multiple_matched_parameters', 'The parameter name "%s" exists multiple times in the parameters cell array', this_param);
        end
    end
    
    % All that error checking, now all we need to do is change the
    % parameter value that follows the name.
    parameters{param_idx+1} = varargin{i_param+1};
end

end

