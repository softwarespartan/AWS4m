classdef ObjectListCache
    
    properties (GetAccess = 'public', SetAccess = 'private')
        prefixSet = java.util.HashSet()
    end
    
    properties(Access = 'private')
        
        % s3 session for client
        s3 = []
        
        % all the object listing keys go in here
        listingKeySet = java.util.HashSet()
    end
    
    methods(Access = 'public')    
        function n = numel(this)
            n = this.listingKeySet.size();
        end
    end
    
    methods (Access = 'public')
        
        function this = ObjectListCache(s3)               
            
            % enforce function signature
            if nargin ~= 1; error('usage: ObjectListCache(s3,bucket,prefix)'); end
            
            % enforace arg1 type
            if ~isa(s3,'aws.s3.Session'); error('input arg1 must be of type aws.s3.Session'); end
               
            % set the s3 session for cache
            this.s3 = s3;
        end
        
        function addPrefix(this,bucket,prefix)            
            
            % enforce arg2 type
            if ~isa(bucket,'char'); error('input arg1 must be of type char'); end
            
            % make sure prefix type cell array with element type char
            if isa(prefix,'char'); prefix = {prefix}; end
            
            % enforce arg3 type
            if ~isa(prefix,'cell') || ~all(cellfun(@(l)isa(l,'char'),prefix))
                error('input arg2 must be cell array with elements of type char'); 
            end
            
            for i = 1:numel(prefix)
                
                % get the ith prefix
                pfi = prefix{i};
            
                % get the unique id for this bucket prefix combo
                uid = ObjectListCache.bucketAndKey2Id(bucket,pfi);

                % for now, error if duplicate bucket://prefix identifier
                if this.prefixSet.contains(uid); error(['cache already contains prefix: ',uid]); end

                % add the uid to the prefix set
                this.prefixSet.add(uid);

                % create a object listing request
                objectListingRequest = com.amazonaws.services.s3.model.ListObjectsRequest();

                % configure the object request
                objectListingRequest.setBucketName(bucket)
                objectListingRequest.setPrefix    (pfi)

                % lets get the list for some bucket
                objectListing = this.s3.client.listObjects(objectListingRequest);

                % process the listing
                this.processListing(objectListing)
            end
        end 
        
        function list = getListing(this)                  
            list = collection2cell(this.listingKeySet);
        end
        
        function list = getPrefixes(this)                 
            list = collection2cell(this.prefixSet);
        end
        
        function bool = containsPrefix(this,bucket,prefix)
            bool = this.prefixSet.contains(                           ...
                       ObjectListCache.bucketAndKey2Id(bucket,prefix) ...
                   );
        end
        
        function bool = contains(this,keys)               
            
            if isa(keys,'char'); keys = {keys}; end
            
            if ~isa(keys,'cell') || ~all(cellfun(@(l)isa(l,'char'),keys))
                error('input arg1 must be cell array with elements of type char'); 
            end
            
            % mem alloc
            bool = false(size(keys));
            
            %check each key
            for i = 1:numel(keys)
                bool(i) = this.listingKeySet.contains(keys{i});
            end
        end
    end
    
    methods(Access = 'private')
        
        function processListing(this,objectListing)   
        
            % get all the object summaries as ArrayList
            objectSummaries = objectListing.getObjectSummaries();
            
            % process each object summary
            for i = 0:objectSummaries.size()-1
                
                % get the i'th object summary
                objsum = objectSummaries.get(i);
                
                % get the object key for this object
                key = objsum.getKey();
                
                % add the object key to the listing
                this.listingKeySet.add(key); 
                
                % note that keys contain prefix (!!)
            end

            % make sure to check for truncation of listing (~)
            if objectListing.isTruncated()
                
                % request next batch of object summaries based on current object listing
                nextObjectListing = this.s3.client.listNextBatchOfObjects(objectListing);
                
                % recurrsively process the new object listings
                this.processListing(nextObjectListing)
            end
        end
    end
    
    methods(Static)
        function bkid = bucketAndKey2Id(bucket,prefix)
            
            if nargin ~= 2; error('usage: bucketAndKey2Id(bucket,prefix)');   end
            
            if ~isa(bucket,'char'); error('input arg1 must be of type char'); end
            
            if ~isa(prefix,'char'); error('input arg2 must be of type char'); end
            
            if numel(bucket)<1; error('input arg1 must have non-zero length');end
            
            if numel(prefix)<1; error('input arg2 must have non-zero length');end
            
            bkid = [bucket,'://',prefix];
        end
    end
end
