function ret = savefigs()
% This function allows you to quickly save all currently open figures with
% a custom filename for each in multiple formats.  To use the function
% simply call savefigs with no arguments, then follow the prompts
%
% Upon execution this function will one-by-one bring each currently open
% figure to the foreground.  Then it will supply a text prompt in the main
% console window asking you for a filename.  It will save that figure to
% that filename in the .fig, .emf, .png, and .eps formats.  
%
% The formats that it saves in can be changed by commenting out or adding
% lines below.
%
% Copyright 2010 Matthew Guidry 
% matt.guidry ATT gmail DOTT com  (Email reformatted for anti-spam)

extension = input('Enter extension to use (blank for .fig). Include the dot.  ','s');

if strcmp(extension,'')
    extension = '.fig';
end

%Check that the input is a valid extension to save figures
if (strcmp(extension,'.cmp') || strcmp(extension,'.emf') || strcmp(extension,'.eps') || strcmp(extension,'.fig') || strcmp(extension,'.jpg') || strcmp(extension,'.pbm') || strcmp(extension,'.pcx') || strcmp(extension,'.pdf') || strcmp(extension,'.pgm') || strcmp(extension,'.png') || strcmp(extension,'.ppm') || strcmp(extension,'.tif'))
fprintf('Extension %s accepted.\n',extension);
pause
hfigs = get(0, 'children');                          %Get list of figures

for m = 1:length(hfigs)
    figure(hfigs(m));                                %Bring Figure to foreground
    filename = input('Filename? (0 to skip or blank to use title with today''s date)  ', 's');%Prompt user
    if strcmp(filename, '0')                        %Skip figure when user types 0
        continue
    elseif strcmp(filename,'')
        ax = findall(gcf,'Type','axes');
        for i=1:numel(ax)
            htitle = get(ax(i),'Title');
            filename = strtrim(get(htitle,'String'));
            if iscell(filename); filename = cat_str_in_cell(filename); end
            if ~isempty(filename); break; end
        end
        filename = strrep(filename,'/','-');
        filename = strrep(filename,':',' ');
        filename = strrep(filename,'\','');
        % Replace % signs with the word percent with reasonable
        % capitalization
        filename = regexprep(filename,'(?<=\w\s+)\%','percent'); % preceded by a letter before a whitespace - lowercase percent
        filename = regexprep(filename, '%', 'Percent'); % otherwise capital
        filename = strtrim(filename);
        filename = sprintf('%s - %s',datestr(today,29),filename);
        fprintf('Saving figure %u as %s.\n',m,filename);
        saveas(hfigs(m), [filename, extension]);
    else
        %saveas(hfigs(m), [filename '.fig']) %Matlab .FIG file
        %saveas(hfigs(m), [filename '.emf']) %Windows Enhanced Meta-File (best for powerpoints)
        saveas(hfigs(m), [filename, extension]); %Standard PNG graphics file (best for web)
        %eval(['print -depsc2 ' filename])   %Enhanced Postscript (Level 2 color) (Best for LaTeX documents)
    end
end
else
    error('extension:invalid','Extension %s not recognized. Be sure to include the ''.''.', extension);
end