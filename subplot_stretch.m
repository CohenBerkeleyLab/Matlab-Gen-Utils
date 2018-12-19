function subplot_stretch(m,n,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
p = inputParser;
p.addParameter('figh', gcf);
p.addParameter('factor',1);

p.parse(varargin{:});
pout = p.Results;

fig = pout.figh;
factor = pout.factor;

fig.Position(3) = fig.Position(3)*factor;
fig.Position(4) = fig.Position(4)*factor;

end

