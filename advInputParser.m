classdef advInputParser < inputParser
    %ADVINPUTPARSER Improved version of the standard input parser (WIP)
    %   Detailed explanation goes here
    
    properties
        AllowFlagRepeats;
    end
    
    properties(SetAccess = private)
        Flags;
        AdvResults;
    end
    
    methods
        
        function obj = advInputParser()
            obj = obj@inputParser();
            obj.Flags = {};
            obj.AllowFlagRepeats = true;
        end
        
        function obj = addFlag(obj, name)
            if ~ischar(name)
                error('advInputParser:addFlag:badInput','NAME must be a character array');
            end
            
            obj.Flags{end+1} = name;
        end
        
        function obj = parse(obj, varargin)
            % Identify flag strings that are in the arguments and mark
            % those present as TRUE. Then remove them and pass the
            % remainder to the superclass parse function, which will
            % handle those.
            
            % Of the properties, we will need to implement CaseSensitive
            % and StructExpand ourselves. We could implement partial
            % matching, but the documentation (for R2017b) indicates that
            % that is only for parameters anyway.
            
            if obj.CaseSensitive
                compare_fxn = @strcmp;
            else
                compare_fxn = @strcmpi;
            end
            
            flag_vals = advInputParser.make_struct_default_val(obj.Flags, false);
            inputs_to_remove = false(size(varargin));
            for i_in = 1:numel(varargin)
                for i_flags = 1:numel(obj.Flags)
                    % If the input doesn't match the current flag, no need
                    % to do anything else
                    if ~compare_fxn(varargin{i_in}, obj.Flags{i_flags})
                        continue
                    end
                    
                    % If it does match, then we need to check if it was
                    % already matched. If AllowFlagRepeats is true
                    % (default) we just mark it to be removed and move on.
                    % Otherwise, it is an error.
                    inputs_to_remove(i_in) = true;
                    if flag_vals.(obj.Flags{i_flags}) && ~obj.AllowFlagRepeats
                        obj.printError('Input parsing error: The flag "%s" was given twice', obj.Flags{i_flags});
                    end
                    flag_vals.(obj.Flags{i_flags}) = true;
                end
            end
            
            varargin(inputs_to_remove) = [];
            % This should populate the Results structure.
            parse@inputParser(obj,varargin{:});
            
            % Add our flags to it.
            obj.AdvResults = advInputParser.combine_structs(obj.Results, flag_vals);
        end
    end
    
    methods(Access = private)
        function obj = printError(obj, message, varargin)
            % I'm not sure what to call on inputParser (or even if it can
            % be called from a subclass) to do this, so we'll write our
            % own. This method will print the requested error message,
            % optionally prefaced by the "Error in {}" where {} is the
            % property FunctionName
            if ~isempty(obj.FunctionName)
                msg_string = sprintf(message, varargin{:});
                formatted_msg = sprintf('Error using <a href="matlab: matlab.internal.language.introspective.errorDocCallback(''%1$s'')">%1$s</a>:\n%2$s', obj.FunctionName, msg_string);
            else
                formatted_msg = sprintf(message, varargin{:});
            end
            
            err_struct = struct('message', formatted_msg,...
                'identifier', 'MATLAB:InputParser:ArgumentFailedValidation',...
                'stack', dbstack(2));
            % We omit the first levels in the stack because those will
            % point to the input parser, and we don't want that - we want
            % the calling function.
            error(err_struct);
        end
    end
    
    methods(Access = private, Static)
        function S = make_struct_default_val(fields, val)
            s_cell = cell(numel(fields)*2,1);
            s_cell(1:2:end) = fields;
            s_cell(2:2:end) = {val};
            S = struct(s_cell{:});
        end
        
        function S_combo = combine_structs(S1, S2)
            fields1 = fieldnames(S1);
            fields2 = fieldnames(S2);
            if any(ismember(fields1, fields2))
                error('advInputParser:combine_structs:dup_field', 'One or more fields are common in S1 and S2')
            end
            
            S_combo = advInputParser.make_struct_default_val(cat(1, fields1, fields2), []);
            for i_fields = 1:numel(fields1)
                S_combo.(fields1{i_fields}) = S1.(fields1{i_fields});
            end
            for i_fields = 1:numel(fields2)
                S_combo.(fields2{i_fields}) = S2.(fields2{i_fields});
            end
        end
    end
    
    
    
end

