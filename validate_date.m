function [ varargout ] = validate_date( date_in )
%VALIDATE_DATE Check if a date can be understood

E = JLLErrors;
if ischar(date_in)
    try 
        date_out = datenum(date_in);
    catch err
        if strcmp(err.identifier, 'MATLAB:datenum:ConvertDateString')
            E.baddate(date_in);
        else
            rethrow(err)
        end
    end
elseif isnumeric(date_in)
    try
        datestr(date_in);
    catch err
        if strcmp(err.identifier, 'MATLAB:datestr:ConvertDateNumber')
            E.baddate('Numerical date (%g) cannot be understood by datestr - value is invalid', date_in)
        else
            rethrow(err)
        end
    end
    date_out = date_in;
else
    E.baddate(date_in);
end

if nargout > 0
    varargout{1} = date_out;
end

end

