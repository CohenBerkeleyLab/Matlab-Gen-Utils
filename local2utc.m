function [ utcsec ] = local2utc( localstr, timezone)
%local2utc: Converts a local time (as string, using military time) into
%seconds after midnight utc.
%
%   Timezones:
%       EST = Eastern Std.      EDT = Eastern Daylight
%       CST = Central Std.      CDT = Central Daylight
%       MST = Mountain Std.     MDT = Mountain Daylight
%       PST = Pacific Std.      PDT = Pacific Daylight

zones = {'est','edt','cst','cdt','mst','mdt','pst','pdt'};
offset = [5, 4, 6, 5, 7, 6, 8, 7];

t = strcmpi(timezone,zones);
colon_pos = strfind(localstr,':');
h = str2double(localstr(1:colon_pos-1)) + offset(t);
m = str2double(localstr(colon_pos+1:end));

utcsec = h*3600+m*60;

end

