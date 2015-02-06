function [ Names, dates, directory, range_files ] = merge_field_names( campaign_name )
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
return_fields = {'pressure_alt', 'gps_alt', 'radar_alt', 'theta', 'no2_lif', 'no2_ncar',...
    'aerosol_extinction', 'aerosol_scattering', 'profile_numbers'}';

% Initialize the return variables
for a=1:numel(return_fields)
    Names.(return_fields{a}) = '';
end

dates = cell(1,2);
directory = '';
range_files = {''};

% All campaign data should be stored in a central directory, this is that
% directory
main_dir = '/Volumes/share2/USERS/LaughnerJ/CampaignMergeMats';

% Parse the campaign name and assign the fields

% DISCOVER-MD
if ~isempty(regexpi(campaign_name,'discover')) && ~isempty(regexpi(campaign_name,'md'))
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_ALT';
    Names.radar_alt = 'A_RadarAlt';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_LIF';
    Names.no2_ncar = 'NO2_NCAR';
    Names.aerosol_extinction = 'EXTamb532';
    Names.aerosol_scattering = 'SCamb532';
    Names.profile_numbers = 'ProfileSequenceNum';
    
    dates = {'2011-07-01','2011-07-31'};
    directory = fullfile(main_dir,'DISCOVER-AQ_MD/P3/1sec/');

% DISCOVER-CA
elseif ~isempty(regexpi(campaign_name,'discover')) && ~isempty(regexpi(campaign_name,'ca'))
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_ALT';
    Names.radar_alt = 'Radar_Altitude';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_MixingRatio_LIF';
    Names.no2_ncar = 'NO2_MixingRatio';
    Names.aerosol_extinction = 'EXTamb532_TSI_PSAP';
    Names.aerosol_scattering = 'SCATamb532_TSI';
    Names.profile_numbers = 'ProfileNumber';
    
    dates = {'2013-01-16','2013-02-06'};
    directory = fullfile(main_dir, 'DISCOVER-AQ_CA/P3/1sec/');
    
% DISCOVER-TX
elseif ~isempty(regexpi(campaign_name,'discover')) && ~isempty(regexpi(campaign_name,'tx'))
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_ALT';
    Names.radar_alt = 'Radar_Altitude';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_MixingRatio_LIF';
    Names.no2_ncar = 'NO2_MixingRatio';
    Names.aerosol_extinction = 'EXT532nmamb_total_LARGE';
    Names.aerosol_scattering = 'SCAT550nm-amb_total_LARGE,';
    Names.profile_numbers = 'ProfileNumber';
    
    dates = {'2013-09-01','2013-09-30'};
    directory = fullfile(main_dir, 'DISCOVER-AQ_TX/P3/1sec/');
    
% SEAC4RS
elseif ~isempty(regexpi(campaign_name,'seac4rs')) || ~isempty(regexpi(campaign_name,'seacers'));
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_ALT';
    Names.radar_alt = 'RadarAlt';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_TDLIF';
    Names.no2_ncar = 'NO2_ESRL'; % This is Ryerson's NO2, not sure if that's different from Weinheimer's
    Names.aerosol_extinction = 'EXT532nmamb_total_LARGE';
    Names.aerosol_scattering = 'SCAT550nmamb_total_LARGE';
    
    dates = {'2013-08-06','2013-09-23'};
    directory = fullfile(main_dir, 'SEAC4RS/DC8/1sec/');
    
    range_files = {fullfile(main_dir, 'SEAC4RS/SEAC4RS_Profile_Ranges.mat')};

% DC3 (not to be confused with the DC8 aircraft)
elseif ~isempty(regexpi(campaign_name,'dc3'))
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_ALT';
    Names.radar_alt = 'RadarAlt';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_TDLIF';
    Names.no2_ncar = 'NO2_ESRL'; % This is Ryerson's NO2, not sure if that's different from Weinheimer's
    Names.aerosol_extinction = 'EXTamb532nm_TSI_PSAP';
    Names.aerosol_scattering = 'SCATamb532nm_TSI';
    
    dates = {'2012-05-18','2012-06-22'};
    directory = fullfile(main_dir, 'DC3/DC8/1sec/');
    
% ARCTAS (-B and -CARB)
elseif ~isempty(regexpi(campaign_name,'arctas'))
    Names.pressure_alt = 'ALTP';
    Names.gps_alt = 'GPS_Altitude';
    Names.radar_alt = 'Radar_Altitude';
    Names.theta = 'THETA';
    Names.no2_lif = 'NO2_UCB';
    Names.no2_ncar = 'NO2_NCAR';
    Names.aerosol_extinction = 0;
    Names.aerosol_scattering = 'Total_Scatter550_nm';
    
    
    if ~isempty(regexpi(campaign_name,'carb'))
        dates = {'2008-06-18','2008-06-24'};
        directory = fullfile(main_dir,'ARCTAS-CARB/DC8/1sec/');
        range_files = {fullfile(main_dir, 'ARCTAS-CARB/ARCTAS-CA Altitude Ranges Exclusive 3.mat')};
    elseif ~isempty(regexpi(campaign_name,'b'))
        dates = {'2008-06-29','2008-07-13'};
        directory = fullfile(main_dir,'ARCTAS-B/DC8/1sec/');
    end
else
    error(E.badinput('Could not parse the given campaign name - see help for this function for suggestions of proper campaign names.'));
end


% Check that all the fields of the output structure are what we expect
fields = fieldnames(Names);
if numel(fields) ~= numel(return_fields) || ~all(strcmp(fields,return_fields))
    error(E.callError('internal:fields_mismatch','Fields of output structure are not what is expected. Make sure any new fields are spelled correctly and that they have been added to ''return_fields'''));
end


end

