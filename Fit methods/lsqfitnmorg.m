function [ m, sm ] = lsqfitnmorg( x, y )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


% https://www.mathworks.com/matlabcentral/newsreader/view_thread/172430
[~,~,V] = svd([x(:),y(:)],0);
m = -V(1,2)/V(2,2);

% For R2: https://online.stat.psu.edu/~ajw13/stat501/SpecialTopics/Reg_thru_origin.pdf
% except I don't think that it's valid for this sort of regression, that
% seems to be for y-residual regression

% http://www.statisticshowto.com/find-standard-error-regression-slope/ and
% http://stattrek.com/regression/slope-confidence-interval.aspx?Tutorial=AP
yhat = m .* x(:);
sm = sqrt( sum( (y(:) - yhat).^2 ) / (numel(x)-2) ) ./ sqrt( sum(x(:) - mean(x)).^2 );
end

