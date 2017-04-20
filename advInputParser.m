classdef advInputParser < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        reqArgs
        optArgs
        paramArgs
    end
    
    methods
        function obj = advInputParser()
            obj.reqArgs = [];
            obj.optArgs = [];
            obj.paramArgs = [];
        end
        
        function addRequired(obj, name, varargin)
            obj.check_existing_args(name);
            if isempty(obj.reqArgs)
                obj.reqArgs = advInputParser.internal_parser(name, [], varargin);
            else
                obj.reqArgs(end+1) = advInputParser.internal_parser(name, [], varargin);
            end
        end
        
        function addOptional(obj, name, def_val, varargin)
        end
        
        function addParameter(obj, name, def_val, varargin)
        end
    end
    
    methods(Access = protected)
        function check_existing_args(obj, new_name)
            exist_names = {};
            if ~isempty(obj.reqArgs) > 0
                exist_names = cat(2, exist_names, obj.reqArgs.name);
            end
            if ~isempty(obj.optArgs) > 0
                exist_names = cat(2, exist_names, obj.optArgs.name);
            end
            if ~isempty(obj.paramArgs) > 0
                exist_names = cat(2, exist_names, obj.paramArgs.name);
            end
            if ismember(new_name, exist_names)
                error('advInputParser:arg_name','An argument named %s already exists', new_name);
            end
        end
    end
    
    methods(Static, Access = protected)
        function S = internal_parser(name, def_val, args)
            recognized_params = {'val_fxn', 'val_msg', 'n_vals'};
            param_def_vals = {@() True, 'The value for parameter %s must fulfill the function %s', 1};
            if ~ischar(name)
                error('advInputParser:arg_name', 'Argument name must be a string');
            end
            S.name = name;
            S.def_val = def_val;
            
            % Set the default values
            for a=1:numel(recognized_params)
                S.(recognized_params{a}) = param_def_vals{a};
            end
            
            if mod(numel(args),2) ~= 0
                error('advInputParser:add_args', 'Every parameter name given to addRequired, addOptional, or addParameter must have a value following it');
            end
            for a=1:2:numel(args)
                if ~ismember(args{a}, recognized_params)
                    error('advInputParser:internal_param_parsing', 'Parameter %s not recognized', args{a})
                end
                S.(args{a}) = args{a+1};
            end
        end
    end
    
end

