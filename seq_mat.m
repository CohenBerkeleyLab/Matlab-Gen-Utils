%This function will return a matrix of the specified dim'ns with each entry
%labeled with its sequential index.

function matrix_out = seq_mat(x,y,z)
if nargin < 2
    y = 1;
    z = 1;
elseif nargin < 3
    z = 1;
end
matrix_out = zeros(x,y,z);

for a=1:x*y*z
    matrix_out(a) = a;
end