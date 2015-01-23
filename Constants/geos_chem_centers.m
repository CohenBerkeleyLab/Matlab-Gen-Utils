function [ lons, lats ] = geos_chem_centers(  )
%geos_chem_centers Generates center points for the 2 x 2.5 deg GEOS-Chem cells.
%   The sole purpose of this function is to return the 2 x 2.5 resolution
%   GEOS-Chem pixel centers. This replicates the edge points given at
%   http://acmg.seas.harvard.edu/geos/doc/man/ in Appendix A2.3
%
%   Josh Laughner <joshlaugh5@gmail.com> 21 Jan 2015

lons = -180:2.5:177.5;
lats = [-89.5,-88:2:88,89.5];

end

