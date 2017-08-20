classdef Session < handle
    %SESSION helper for AWS S3 client, credentials, connection, operations
    
    properties (GetAccess = 'public', SetAccess = 'private')
        client = []
    end
    
    methods(Access = 'public', Static)
        
        function sess = init(region,credentials)
            
            % create presistent instance for to call getInstance()
            persistent localInstance;
            
            % enforce function signature size
            if nargin ~= 1 && nargin ~= 2; error('usage Session(region,credentials)'); end
                        
            % enforce arg1 types
            if ~isa(region,'com.amazonaws.regions.Region') && ~isa(region,'char')
                error('input arg1 must be of type com.amazonaws.regions.Region or char')
            end
            
            % enforce arg2 type
            if nargin == 2 && ~isa(credentials,'com.amazonaws.auth.AWSCredentialsProvider')
                error('input arg2 must be of type com.amazonaws.auth.AWSCredentialsProvider')
            end
            
            % if no credential provider specified as input arg, need to init default provider
            if nargin == 1
                credentials = com.amazonaws.auth.DefaultAWSCredentialsProviderChain();
            end
            
            % if region is char, need to resolve which regions string corresponds to 
            if isa(region, 'char')
                
                % init region object from region name string/char
                try region = aws.region.fromName(region);
                    
                % the region name/identifier must not be valid 
                catch e
                    error('arg1 of type char must be valid region name (see aws.region)')
                end
            end
            
            % call the constructor to create local instance
            localInstance = aws.s3.Session(region,credentials);
            
            % pass reference to instance of session
            sess = localInstance;
        end
    end
    
    methods (Access = 'private')
        
        function this = Session(region,credentials)
            
            % init S3 client
            this.client = com.amazonaws.services.s3.AmazonS3Client(credentials);
            
            % set the region
            this.client.setRegion(region);
        end
    end
    
end

