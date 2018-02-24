function [ dest ] = copy_structure_fields(source, dest, varargin)
%COPY_STRUCTURE_FIELDS Copies fields values from one struct to another
%   DEST_OUT = COPY_STRUCTURE_FIELDS( SOURCE, DEST ) Given two structures,
%   SOURCE and DEST, return a structure with the same fields as DEST where
%   each field has the value of that field in SOURCE.
%
%   DEST_OUT = COPY_STRUCTURE_FIELDS( SOURCE, FIELDS_TO_COPY ) If instead
%   given a cell array of strings FIELDS_TO_COPY, those fields will be
%   copied from SOURCE into a structure DEST_OUT with those fields.
%
%   DEST_OUT = COPY_STRUCTURE_FIELDS( SOURCE, DEST, FIELDS_TO_COPY ) This
%   form returns DEST_OUT with all the same fields as the input DEST
%   structure but only copies the fields specified in the cell array
%   FIELDS_TO_COPY. If there are additional fields in DEST not included in
%   FIELDS_TO_COPY, they retain their input values in DEST_OUT. (This is
%   useful if trying to place the output in a non-scalar structure and so
%   it must have the same fields as the rest of the structure, but not all
%   those fields are in SOURCE or you do not want to overwrite all of the
%   fields.)
%
%   DEST_OUT = COPY_STRUCTURE_FIELDS( ___, 'substructs' ) will search not
%   just SOURCE for the fields to copy but also any substructures within
%   SOURCE. I.e., the fields to copy do not need to be in the top level of
%   SOURCE. This may be used with any of the above syntaxes.
%
%   DEST_OUT = COPY_STRUCTURE_FIELDS( ___, 'ignore_error' ) will ignore
%   errors caused by trying to copy a field from SOURCE that does not
%   exist. Instead, the original value (if DEST is given as a structure in
%   the input) or the default value of an empty array (if just
%   FIELDS_TO_COPY is given) is retained for that field.

%%%%%%%%%%%%%%%%%
% INPUT PARSING %
%%%%%%%%%%%%%%%%%

E = JLLErrors;

p = advInputParser;
p.addOptional('fields_to_copy', {}, @iscellstr);
p.addFlag('substructs');
p.addFlag('ignore_error');

p.parse(varargin{:});
pout = p.AdvResults;

ignore_error = pout.ignore_error;

if ~isstruct(source) || ~isscalar(source)
    E.badinput('SOURCE must be a scalar structure');
end

if iscellstr(dest)
    fields_to_copy = dest;
    dest = make_empty_struct_from_cell(dest, fields_to_copy);
elseif isstruct(dest)
    if ~isscalar(dest)
        E.badinput('DEST must be a scalar, if given as a structure');
    end
    
    fields_to_copy = pout.fields_to_copy;
    if isempty(fields_to_copy)
        fields_to_copy = fieldnames(dest);
    end
end

if pout.substructs
    finder_fxn = @find_substruct_field;
    err_addendum = ' or any of its substructures';
else
    finder_fxn = @find_field;
    err_addendum = '';
end

%%%%%%%%%%%%%%%%%
% MAIN FUNCTION %
%%%%%%%%%%%%%%%%%

for i = 1:numel(fields_to_copy)
    try
        dest.(fields_to_copy{i}) = finder_fxn(source, fields_to_copy{i});
    catch err
        if strcmp(err.identifier, 'MATLAB:nonExistentField')
            % Reformat the message to better reflect the true cause of the
            % error
            if ~ignore_error
                error('MATLAB:nonExistentField', 'Could not find field "%s" in SOURCE%s', fields_to_copy{i}, err_addendum);
            end
        else
            rethrow(err)
        end
    end
end


end

function val = find_field(S, field_name)
val = S.(field_name);
end