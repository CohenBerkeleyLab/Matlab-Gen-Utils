function [  ] = quicksave(  )
%QUICKSAVE Quickly save the current figure as .fig and .jpg
%   Utility function to save the current figure as both a .fig (for
%   editing) and a .jpg (for looking at w/o matlab). If the figure has been
%   saved before, it will resave over those files. If it hasn't been saved,
%   it will save with the title or if the title is empty, the figure
%   number. Both of the latter two will save in the current directory.
%
%   Josh Laughner <joshlaugh5@gmail.com> 16 June 2015

% Check that some figure is open

if isempty(get(0,'children'))
    return
end

% See if the file has been saved before, if so, we'll be saving over that
savename = get(gcf,'FileName');
if ~isempty(savename)
    ind = strfind(savename,'.');
    ind = ind(end);
    savename = savename(1:ind-1); % remove the file extension
else
    savename = get(get(gca,'title'),'string');
    if ~isempty(savename)
        savename = repexprep(savename,'[^\d\w_\/]');
    else
        savename = sprintf('Figure%d',get(gcf,'Number'));
        % Do not save over another file named "FigureN" 
        s=1;
        savename_orig = savename;
        while check_exist(savename)
            savename = sprintf('%s-%02d',savename_orig,s);
            s = s+1;
        end
    end
    % Set the figure filename so it knows what to do if you press the
    % "save" icon
    fullsavename = fullfile(pwd,strcat(savename,'.fig'));
    set(gcf,'FileName',fullsavename)
end

% All that just to get the filename! Now actually save.
savefig(savename)
saveas(gcf,savename,'jpg');



end

function e = check_exist(savename)
if exist(strcat(savename,'.fig'),'file')
    e = true;
    return
elseif exist(strcat(savename,'.jpg'),'file')
    e = true;
    return
end
e = false;
end