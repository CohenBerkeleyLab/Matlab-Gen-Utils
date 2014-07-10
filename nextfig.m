function [ fignum ] = nextfig(  )
%nextfig() Returns the next unused figure number

figs = findall(0, 'Type','Figure');
if isempty(figs);
    fignum = 1;
else
    fignum = max(figs) + 1;
end

end

