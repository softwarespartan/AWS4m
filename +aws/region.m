classdef (Sealed) region
    %REGION Each region is a separate geographic area. Each region has multiple isolated locations known as Availability Zones.
    
    properties (Constant)
       US_EAST_1      = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.US_EAST_1     )
       US_EAST_2      = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.US_EAST_2     )
       US_WEST_1      = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.US_WEST_1     )
       US_WEST_2      = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.US_WEST_2     )
       EU_WEST_1      = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.EU_WEST_1     )
       EU_WEST_2      = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.EU_WEST_2     )
       EU_CENTRAL_1   = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.EU_CENTRAL_1  )
       AP_SOUTH_1     = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.AP_SOUTH_1    )
       AP_SOUTHEAST_1 = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.AP_SOUTHEAST_1)
       AP_SOUTHEAST_2 = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.AP_SOUTHEAST_2)
       AP_NORTHEAST_1 = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.AP_NORTHEAST_1)
       AP_NORTHEAST_2 = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.AP_NORTHEAST_2)
       SA_EAST_1      = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.SA_EAST_1     )
       CN_NORTH_1     = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.CN_NORTH_1    )
       CA_CENTRAL_1   = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.CA_CENTRAL_1  )
       GovCloud       = com.amazonaws.regions.Region.getRegion(com.amazonaws.regions.Regions.GovCloud      )
    end
    
    methods(Static)
        function r = fromName(regionName)
            r = com.amazonaws.regions.Region.getRegion( ...
                       com.amazonaws.regions.Regions.fromName(regionName));
        end 
    end
end

