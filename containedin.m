function [ xx ] = containedin( A, B )
%containedin Determines what elements of A are present in B.
%   Simple function that loops through each element in A and tests if 
%   any(A(i) == B).  Returns a logical matrix the same size as A.

xx = false(size(A));
for i=1:numel(A)
    if any(A(i) == B(:))
        xx(i) = true;
    end
end


end

