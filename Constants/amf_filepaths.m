function [ fileDamf, fileTmp ] = amf_filepaths( )
%amf_filepaths Returns the file paths for the dAmf file (scattering weights
%table) and the nmcTmpYr file (temperature profiles for correction factor
%alpha)
%   Update as needed if file paths change.  This function should always be
%   referenced for these paths to make code as portable as possible.

amf_tools_path = '/Users/Josh/Documents/MATLAB/BEHR/AMF_tools';
fileTmp = fullfile(amf_tools_path,'nmcTmpYr.txt');
fileDamf = fullfile(amf_tools_path,'damf.txt');

end

