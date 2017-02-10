classdef GlobeGrid < matlab.System
    %GLOBEGRID Representation of lat/lon grids
    %   Detailed explanation goes here
    
    properties
        LonRes
        LatRes
        Projection
        CenterLon
        CenterLat
        DomainLon = [-180 180];
        DomainLat = [-90 90];
    end
    properties(Hidden,Transient)
        ProjectionSet = matlab.system.StringSet({'equirectangular'})
    end
    
    methods
        function obj = GlobeGrid(lon_res, varargin)
            p = inputParser;
            p.addOptional('lat_res',[]);
            p.addParameter('projection','equirectangular');
            p.addParameter('domain', 'world');
            p.parse(varargin{:});
            
            lat_res = p.Results.lat_res;
            proj = p.Results.projection;
            domain = p.Results.domain;
            
            if nargin < 1
                error('globegrid:bad_input','GlobeGrid requires at least one input (grid resolution) to the constructor')
            end
            obj.LonRes = lon_res;
            if ~isempty(lat_res)
                obj.LatRes = lat_res;
            else
                obj.LatRes = lon_res;
            end
            obj.Projection = proj;
            obj.SetDomain(domain);
        end
        
        function SetDomain(obj, domain)
            if isnumeric(domain)
                if ~isvector(domain) || numel(domain) ~= 4
                    error('globegrid:bad_input', 'Numeric domain limits must be given as a four element vector')
                elseif any(domain(1:2) < -180 | domain(1:2) > 180)
                    error('globegrid:bad_input', 'The first two elements of a numeric domain limit are longitude and must lie between -180 and 180')
                elseif any(domain(3:4) < -90 | domain(3:4) > 90)
                    error('globegrid:bad_input', 'The third and fourth elements of a numeric domain limit are latitude and must lie between -90 and 90')
                end
                
                obj.DomainLon = [min(domain(1:2)), max(domain(1:2))];
                obj.DomainLat = [min(domain(3:4)), max(domain(3:4))];;
            elseif ischar(domain)
                switch lower(domain)
                    case 'world'
                        obj.DomainLon = [-180 180];
                        obj.DomainLat = [-90 90];
                    case 'us'
                        obj.DomainLon = [-125 -65];
                        obj.DomainLat = [25 50];
                    otherwise
                        error('globegrid:bad_input','Domain name %s not recognized', domain)
                end
            else
                error('globegrid:bad_input', 'To set a domain, pass either a four element numeric vector ([lonmin lonmax latmin latmax]) or a string')
            end
            obj.check_domain()
        end
        
        function [grid_lon, grid_lat] = GetGridCenters(obj)
            switch obj.Projection
                case 'equirectangular'
                    [grid_lon, grid_lat] = obj.make_equirect_grid_centers();
                otherwise
                    error('globegrid:projection','Projection %s not implemented in GetGridCenters method',obj.Projection)
            end
        end
        
        function [grid_lon, grid_lat] = GetGridCorners(obj)
            switch obj.Projection
                case 'equirectangular'
                    [grid_lon, grid_lat] = obj.make_equirect_grid_corners();
                otherwise
                    error('globegrid:projection','Projection %s not implemented in GetGridCorners method',obj.Projection)
            end
        end
    end
    
    methods(Access=private)
        function check_domain(obj)
            % Check that the resolution divides the domain evenly, if we're just using the domain boundaries
            % (not a center coordinate)
            warncell = {};
            if mod(obj.DomainLon(2) - obj.DomainLon(1), obj.LonRes) ~= 0
                warncell{end+1} = 'longitudinal';
            end
            if mod(obj.DomainLat(2) - obj.DomainLat(1), obj.LatRes) ~= 0
                warncell{end+1} = 'latitudinal';
            end
            if ~isempty(warncell)
                warning('The domain is not a multiple of the resolution in the %s direction', strjoin(warncell, ' and '))
            end
        end

        function [grid_lon, grid_lat] = make_equirect_grid_centers(obj)
            lonvec = (obj.DomainLon(1)+obj.LonRes/2):obj.LonRes:(obj.DomainLon(2)-obj.LonRes/2);
            latvec = (obj.DomainLat(1)+obj.LatRes/2):obj.LatRes:(obj.DomainLat(2)-obj.LatRes/2);
            [grid_lat, grid_lon] = meshgrid(latvec, lonvec);
        end
        
        function [grid_lon, grid_lat] = make_equirect_grid_corners(obj)
            lonvec = obj.DomainLon(1):obj.LonRes:obj.DomainLon(2);
            latvec = obj.DomainLat(1):obj.LatRes:obj.DomainLat(2);
            [grid_lat, grid_lon] = meshgrid(latvec, lonvec);
        end
    end
    
end

