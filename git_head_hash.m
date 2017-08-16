function [ githead ] = git_head_hash( git_dir )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

currdir = cd(behr_repo_dir);
try
    [gitstat, githead] = system('git rev-parse HEAD');
catch err
    cd(currdir);
    rethrow(err);
end
cd(currdir);

if gitstat ~= 0
    githead = 'Unknown';
end

githead = strtrim(githead);

end

