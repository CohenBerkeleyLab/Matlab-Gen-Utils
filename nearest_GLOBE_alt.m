function [ alt ] = nearest_GLOBE_alt( lon, lat )
%nearest_GLOBE_alt Returns the GLOBE altitude nearest the input lat/lon

globe_dir = '/Volumes/share/GROUP/SAT/BEHR/GLOBE_files';
[terpres, refvec] = globedem(globe_dir,1,[25, 50],[-125, -65]);

cell_count = refvec(1);
globe_latmax = refvec(2); globe_latmin = globe_latmax - size(terpres,1)*(1/cell_count);
globe_lat_matrix = (globe_latmin + 1/(2*cell_count)):(1/cell_count):globe_latmax;
globe_lat_matrix = globe_lat_matrix';
globe_lat_matrix = repmat(globe_lat_matrix,1,size(terpres,2));

globe_lonmin = refvec(3); globe_lonmax = globe_lonmin + size(terpres,2)*(1/cell_count);
globe_lon_matrix = globe_lonmin + 1/(2*cell_count):(1/cell_count):globe_lonmax;
globe_lon_matrix = repmat(globe_lon_matrix,size(terpres,1),1); 

dlon = abs(globe_lon_matrix - lon); dlat = abs(globe_lat_matrix - lat);
dtotal = dlon+dlat;

xx = (dtotal(:) == min(dtotal(:)));

alt = terpres(xx);

end

