classdef Provider
    %PROVIDER helper factory methods to create cendentials providers and chains of providers
    
    methods (Static)
        function credentialsProvider = fromCredentials(accessKey, secretKey)
            
            % enforce number of input args
            if ~nargin == 2; error('usage: fromCredentials(accessKey,secretKey)'); end
            
            % enforce input arg1 types
            if ~isa(accessKey,'char'); error('input arg1 must be of type char'); end
            
            % enforce input arg2 types
            if ~isa(secretKey,'char'); error('input arg2 must be of type char'); end
            
            % create basic set of credentials
            credentials = com.amazonaws.auth.BasicAWSCredentials(accessKey,secretKey);
            
            % wrap credentials with a static provider
            credentialsProvider = com.amazonaws.auth.AWSStaticCredentialsProvider(credentials);
        end
        
        function credentialsProviderChain = default()
            credentialsProviderChain = com.amazonaws.auth.DefaultAWSCredentialsProviderChain();
        end
    end
end

