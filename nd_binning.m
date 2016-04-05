function [ top_bins, hist_mat, centers, edges ] = nd_binning( points, binmode, bins, varnames )
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

E=JLLErrors;

if ~ismatrix(points)
    E.badinput('points must be a matrix where the first dimension contains all the data points and the second the variables')
elseif size(points,1) < size(points,2)
    warning('There seem to be fewer data points than variables - are you sure the input is oriented properly?')
end

if any(isnan(points(:)))
    warning('Any points containing NaNs will not be included in binning');
    points(any(isnan(points),2),:) = [];
end

allowed_bin_modes = {'nbins'};
switch binmode
    case 'nbins'
        if ~isnumeric(bins) || ~isscalar(bins) || mod(bins,1) ~= 0 || bins <= 0
            E.badinput('For binmode %s, bins must be a scalar, positive, whole number')
        end
    otherwise
        E.badinput('binmode must be one of: %s',strjoin(allowed_bin_modes,', '));
end

if ~exist('varnames','var')
    varnames = cell(1,size(points,2));
    for a=1:numel(varnames)
        varnames{a} = sprintf('Var %d',a);
    end
end
varnames{end+1} = 'Count';
varnames{end+1} = 'Percent';
varnames{end+1} = 'Edges';
%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% MAIN FUNCTION %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%
nvar = size(points,2);
edges = cell(1,nvar);
centers = cell(1,nvar);
n_bin_vec = zeros(1,nvar);
switch binmode
    case 'nbins'
        for a=1:nvar
            range_a = [min(points(:,a)), max(points(:,a))*1.001]; % give the max a little extra so that the max value gets included in the last bin
            edges{a} = linspace(range_a(1), range_a(2), bins+1);
            centers{a} = mean([edges{a}(1:end-1); edges{a}(2:end)],1);
        end
        n_bin_vec = ones(1,nvar)*bins;
end

% Odds are there will be more bins than points (i.e. parts of the n-D space
% will be essentially unoccupied) so we will iterate over the points to bin
% them.

hist_mat = zeros(n_bin_vec);

for a=1:size(points,1)
    xx = cell(1,nvar);
    for b=1:nvar
        xx{b} = find(points(a,b) >= edges{b}(1:end-1) & points(a,b) < edges{b}(2:end));
    end
    hist_mat(xx{:}) = hist_mat(xx{:}) + 1;
end

% Find the 10 most populous bins to return as top_bins. 
n_top = 10;
lin_inds = findbysize(hist_mat,n_top,'largest');
bin_vals = cell(n_top,nvar+3);
for a=1:numel(lin_inds)
    % The perambulation with the cell array tmp seems to be the best way to
    % get ind2sub to output an arbitrary number of subscript indices,
    % rather than a linear index.
    tmp = cell(1,nvar);
    [tmp{:}] = ind2sub(size(hist_mat), lin_inds(a));
    bin_edges = nan(nvar,2);
    count = hist_mat(tmp{:});
    for b=1:nvar
        bin_vals{a,b} = centers{b}(tmp{b});
        bin_edges(b,:) = [edges{b}(tmp{b}:tmp{b}+1)];
    end
    bin_vals{a,nvar+1} = count;
    bin_vals{a,nvar+2} = count/size(points,1)*100;
    bin_vals{a,nvar+3} = bin_edges;
end
bin_vals = flipud(sortrows(bin_vals,nvar+1));

top_bins = array2table(bin_vals,'VariableNames',varnames);

end

