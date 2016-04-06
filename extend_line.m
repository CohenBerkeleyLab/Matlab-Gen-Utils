function [ output_args ] = extend_line( line_handle, x_lims )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

line_x = get(line_handle,'XData');
line_y = get(line_handle,'YData');

line_slope = (line_y(end) - line_y(1)) / (line_x(end) - line_x(1));

new_x = [min(x_lims), line_x, max(x_lims)];
new_y_min = (new_x(1) - new_x(2)) * line_slope + new_x(2);
new_y_max = (new_x(end) - new_x(end-1)) * line_slope + new_x(end-1);

new_y = [new_y_min, line_y, new_y_max];

set

end

