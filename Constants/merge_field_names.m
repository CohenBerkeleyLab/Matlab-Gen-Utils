function [ Names ] = merge_field_names( campaign_name )
%merge_field_names Returns field names of key fields in merge files
%   Different field campaigns name the same data differently.  This
%   function will return a structure with all the appropriate field names
%   for use in any other functions.  This allows this function to be a
%   central clearing house for field names that any other function can make
%   use of.
%
%   Valid campaign designations are:
%       arctas
%       seac3rs/seacers
%       discover-md/ca/tx
%   This function will try to match the input string to one of these; it is
%   not especially picky, so for example discovermd, Discover-MD, and
%   Discover-AQ MD will all successfully indicate to use the field names
%   from the Maryland Discover-AQ campaign.  If no campaign name can be
%   matched, an error is thrown.
%
%   Fields returned are:
%       pressure_alt - pressure derived altitude
%       gps_alt - GPS derived altitude
%       radar_alt - radar altitude, i.e. altitude above the ground
%       theta - potential temperature measurements
%       no2_lif - Our (Cohen group) NO2 measurements
%       no2_ncar - Andy Weinheimer's NO2 measurmenets
%       aerosol_extinction - Aerosol extinction measurments at green 
%           wavelengths
%       aerosol_scattering - Aerosol scattering only measurements (no
%           absorption)
%       aerosol_ssa - Aerosol single scattering albedo measurements
%       profile_numbers - The field with the number assigned to each
%           profile. Only a field in DISCOVER campaigns.
%   Any field that doesn't exist for a given campaign returns an empty
%   string.

E = JLLErrors;

% Setup the fields the output structure is expected to have - this will be
% validated against before the structure is returned.  That way, if I make
% a mistake adding a new campaign we can avoid instances of other functions
% expecting a field to be no2_lif and getting one that is NO2_LIF.  ADD ANY
% ADDITIONAL FIELDS TO RETURN HERE.
return_fields = {pressure_alt, gps_alt, radar_alt, theta, no2_lif, no2_ncar,...
    aerosol_extinction, aerosol_scattering, profile_numbers};

% Initialize the return structure
for a=1:numel(return_fields)
    Names.(return_fields{a}) = '';
end

% Parse the campaign name and assign the fields
if ~isempty(regexpi(campaign_name,'discover')) && ~isempty(regexpi('md'))
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_ALT';
    Names.radar_alt = 'A_RadarAlt';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_LIF';
    Names.no2_ncar = 'NO2_NCAR';
    Names.aerosol_extinction = 'EXTamb532';
    Names.aerosol_scattering = 'SCamb532';
    Names.profile_numbers = 'ProfileSequenceNum';
elseif ~isempty(regexpi(campaign_name,'discover')) && ~isempty(regexpi('ca'))
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_ALT';
    Names.radar_alt = 'Radar_Altitude';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_MixingRatio_LIF';
    Names.no2_ncar = 'NO2_MixingRatio';
    Names.aerosol_extinction = 'EXTamb532_TSI_PSAP';
    Names.aerosol_scattering = '?';
    Names.profile_numbers = 'ProfileNumber';
elseif ~isempty(regexpi(campaign_name,'discover')) && ~isempty(regexpi('tx'))
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_ALT';
    Names.radar_alt = 'Radar_Altitude';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_MixingRatio_LIF';
    Names.no2_ncar = 'NO2_MixingRatio';
    Names.aerosol_extinction = 'EXT532nmamb_total_LARGE';
    Names.aerosol_scattering = '?';
    Names.profile_numbers = 'ProfileNumber';
elseif ~isempty(regexpi(campaign_name,'seac3rs')) || ~isempty(regexpi('seacers'));
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_ALT';
    Names.radar_alt = 'RadarAlt';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_TDLIF';
    Names.no2_ncar = 'NO2_ESRL'; % double check this
    Names.aerosol_extinction = 'EXT532nmamb_total_LARGE';
    Names.aerosol_scattering = 'SCAT550nmamb_total_LARGE';
elseif ~isempty(regexpi(campaign_name,'arctas'))
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_Altitude';
    Names.radar_alt = 'Radar_Altitude';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_UCB';
    Names.no2_ncar = 'NO2_NCAR';
    Names.aerosol_extinction = '';
    Names.aerosol_scattering = ''; % figure these two out
else
    E.badinput('Could not parse the given campaign name - see help for this function for suggestions of proper campaign names.');
end


% Check that all the fields of the output structure are what we expect
fields = fieldnames(Names);
if numel(fields) ~= numel(return_fields) || ~all(strcmp(fields,return_fields))
    E.callError('internal:fields_mismatch','Fields of output structure are not what is expected. Make sure any new fields are spelled correctly and that they have been added to ''return_fields''');
end


end

