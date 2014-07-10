function modis_reader(filename, vg_num)
filepath = '/Users/Josh/Documents/MATLAB/Ashleys Code/';
fullpath = [filepath, filename];
modis = hdfinfo(fullpath);
b = length(modis.Vgroup(1).Vgroup(vg_num).SDS);

for a=1:b
fprintf('%u',a);
fprintf('%s',' : ');
fprintf('%s',modis.Vgroup(1).Vgroup(vg_num).SDS(a).Name)
disp(' ')
end
