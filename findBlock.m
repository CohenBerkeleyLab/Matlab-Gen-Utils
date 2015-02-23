function blocks = findBlock(vec)
% Returns an n x 3 matrix with the indicies of blocks of contiguous values
% in the input vector. The first two columns are the start and end
% indicies, the last is the value of those entries.

E = JLLErrors;

% Check the input
narginchk(1,1);
if ~isvector(vec)
    error(E.badinput('''vec'' must be a vector'));
end

% Set up blocks with the maximum possible number of blocks.  We'll remove
% extra entries at the end.
n = numel(vec);
blocks = nan(n, 3);

% Loop through the vector. For each entry, go through the following values
% until a different one is found.

i = 1;
b = 1;
while true 
    start_ind = i;
    chk_val = vec(i);
    while true
        i = i+1;
        if i >= n || vec(i) ~= chk_val;
            i = i-1;
            break
        end
    end
    last_ind = i;
    blocks(b,:) = [start_ind, last_ind, chk_val];
    b = b+1;
    i = i+1;
    if i > n
        break
    end
end

blocks(b:end,:) = [];

end