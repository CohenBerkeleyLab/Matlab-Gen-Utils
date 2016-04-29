function [ user_ans ] = ask_number( prompt, varargin )
%ASK_NUMBER Will ask the user to input a numeric value
%   Asks the user the question given in PROMPT. Four parameters exist:
%
%   'default' - choose a default value for the response.
%
%   'softquit' - boolean, if false (default), will exit if the user enters
%   'q' at any point by throwing an error. Unlike other ask functions, if
%   true, this will cause the function to return a NaN.
%
%   'testfxn' - a function handle to a function that will test the value
%   given by the user. 
%
%   'testmsg' - a string that will be printed if the test given by
%   'testfxn' fails. If this is not passed, it will simply say that the
%   number must fulfill the function given.
%
%   Josh Laughner <joshlaugh5@gmail.com> 26 Jan 2016

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% INPUT CHECKING %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%

E = JLLErrors;
if ~ischar(prompt)
    E.badinput('prompt must be a string')
end

p = inputParser;
p.addParameter('default',[]);
p.addParameter('softquit',false,@(x) (islogical(x) && isscalar(x)));
p.addParameter('testfxn',@(x) true);
p.addParameter('testmsg','');
p.parse(varargin{:});
pout = p.Results;

default = pout.default;
if isempty(default)
    use_default = false;
else
    use_default = true;
    if ~isnumeric(default) || ~isscalar(default)
        E.badinput('default must be a scalar number')
    end
end
softquit = pout.softquit;

testfxn = pout.testfxn;
try
    testfxn(0);
catch err
    E.badinput('Evaluation of testfxn(0) produced the error: "%s" - the function must accept a scalar number as input.',err.message)
end
if ~isa(testfxn,'function_handle') || ~isscalar(testfxn(0)) || ~islogical(testfxn(0))
    E.badinput('testfxn must be a handle to a function that returns a scalar logical value');
end
testmsg = pout.testmsg;
if ~ischar(testmsg)
    E.badinput('testmsg must be a string')
end

if use_default
    fprintf('%s (%g is default): ', prompt, default);
else
    fprintf('%s: ', prompt);
end

while true
    user_ans = lower(input('', 's'));
    if use_default && isempty(user_ans)
        user_ans = default;
        return
    elseif strcmpi(user_ans, 'q')
        if softquit
            user_ans = NaN;
            return
        else
            E.userCancel()
        end
    else
        user_ans = str2double(user_ans);
        if isnan(user_ans)
            fprintf('\tNumber not recognized by str2double: number must be a single value (q to quit): ');
        elseif ~testfxn(user_ans)
            if isempty(testmsg)
                fprintf('\tValue must cause the function %s to return true. Try again, or q to quit: ', functiontostring(testfxn));
            else
                fprintf('\t%s (q to quit): ', testmsg);
            end
        else
            return
        end
    end
    
end

end
