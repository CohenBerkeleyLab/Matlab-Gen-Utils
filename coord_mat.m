%Returns a matrix whose values represent the xyz coordinates (or xy
%coordinates for a 2D matrix). matrices of greater than length 9 will be
%weird.

function matrix_out = coord_mat(x, y, z)
if nargin < 2
    y = 1;
    z = 1;
elseif nargin < 3
    z = 1;
end
matrix_out = zeros(x,y,z);


for a=1:x
    for b=1:y
        for c=1:z
            if z==1
                matrix_out(a,b,c) = a*10 + b;
            else
                matrix_out(a,b,c) = a*100 + b*10 + c;
            end
        end
    end
end
            