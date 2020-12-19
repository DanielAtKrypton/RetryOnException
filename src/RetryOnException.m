classdef RetryOnException < handle
    %RETRYONEXCEPTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(Access = private)
        numRetries
        timeToWaitSeconds
        rateControl
    end
    
    methods
        function obj = RetryOnException(numRetries, rateControl)
            %RETRYONEXCEPTION Construct an instance of this class
            %   Detailed explanation goes here
            obj.numRetries = numRetries;
            obj.rateControl = rateControl;
        end
        
        function returnVal = shouldRetry(obj)
            %SHOULDRETRY Returns true if a retry can be attempted.
            %   @return  True if retries attempts remain; else false 
            returnVal = (obj.numRetries >= 0);
        end
        
        function obj = exceptionOccurred(obj, error)
            %EXCEPTIOOCURRED Call when an exception has occurred in the block.
            % If the retry limit is exceeded, throws an exception.
            % Else waits for the specified time.
            % @throws Exception
            obj.numRetries = obj.numRetries-1;
            if(~obj.shouldRetry())
                ME = MException('RetryOnException:RetryLimitExceeded', ...
                'Retry Limit exceeded');
                ME = addCause(ME, error);
                throw(ME);
            end
            waitfor(obj.rateControl);
        end
    end
end