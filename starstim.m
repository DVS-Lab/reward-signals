classdef starstim < handle
    % Wrapper class to simplify interaction with the MatNIC toolbox.
    % BK - Feb 2016
    
    % Public properties
    properties (SetAccess=public, GetAccess= public)
        fake@logical= false; % Use for debugging. Fake connection to host.
    end
    
    % Public Get, but set through functions or internally
    properties (SetAccess=protected, GetAccess= public)
        host@char;          % Host that the NIC software runs on/
        template@char;      % Template to load on the host/
        sock;               % Socket for communication with the host.
        z@double;           % Impedance
        zTime@double;          % Impedance measurement times
        
        tacsTimer@timer =timer;    % Created as needed in o.tacs
    end
    
    % Dependent properties
    properties (Dependent)
        status@char;        % Current status (queries the device)
    end
    
    methods % get/set dependent functions
        function [v] = get.status(o)
            if o.fake
                v = ' Fake OK';
            else
                [ret, v] = MatNICQueryStatus(o.sock);
            end
        end
    end
    
    methods % Public
        
        function disp(o)
            disp(['Starstim Host: ' o.host  ' Status: ' o.status]);
        end
        
        % Constructor. Provide a host, template and (optional the fake
        % boolean to simulate a StarStim device).
        function [o] = starstim(h,tmplate,fake)
            o.host = h;
            o.template = tmplate;
            if nargin<2
                fake= false;
            end
            o.fake = fake;
            
            % Connect to the device, load the template
            if o.fake
                disp('Fake conect');
            else
                [ret, sttus, o.sock] = MatNICConnect(o.host);
                o.checkRet(ret,'Host');
                ret = MatNICLoadTemplate(o.template, o.sock);
                o.checkRet(ret,'Template');
            end
            
            % Delete any remaning timers (if the previous run was ok, there
            % should be none)
            timrs = timerfindall;
            if ~isempty(timrs)
                disp('Deleting timer stragglers.... last experiment not terminated propertly?');
                delete(timrs)
            end
        end
        
        function tacs(o,amplitude,channel,transition,duration,frequency)
            % function tacs(o,amplitude,channel,transition,duration,frequency)
            % Apply tACS at a given amplitude, channel, frequency. The current is ramped
            % up and down in 'transition' milliseconds and will last 'duration'
            % milliseconds (including the transitions).
            
            if duration>0 && isa(o.tacsTimer,'timer') && isvalid(o.tacsTimer) && strcmpi(o.tacsTimer.Running,'off')
                error('tACS pulse already on? Cannot start another one');
            end
            
            if o.fake
                disp([ datestr(now,'hh:mm:ss') ': tACS frequency set to ' num2str(frequency) ' on channel ' num2str(channel)]);
            else
                ret = MatNICOnlineFtacsChange (frequency, channel, o.sock);
                o.checkRet(ret,'FtacsChange');
            end
            if o.fake
                disp(['tACS amplitude set to ' num2str(amplitude) ' on channel ' num2str(channel) ' (transition = ' num2str(transition) ')']);
            else
                ret = MatNICOnlineAtacsChange(amplitude, channel, transition, o.sock);
                o.checkRet(ret,'AtacsChange');
            end
            
            if duration ==0
                toc
                stop(o.tacsTimer);
                delete (o.tacsTimer);
                % It has done its work but deleteing results in warnings
                % becasue were till in a callback..
            else
                % Setup a timer to end this stimulation at the appropriate
                % time
                tic
                off  = @(timr,events,obj,chan,trans) tacs(obj,0*chan,chan,trans,0,0);
                o.tacsTimer  = timer('name','starstim.tacs');
                o.tacsTimer.StartDelay = (duration-2*transition)/1000;
                o.tacsTimer.ExecutionMode='SingleShot';
                o.tacsTimer.TimerFcn = {off,o,channel,transition};
                start(o.tacsTimer);
            end
            
        end
        
        function start(o)
            % Trigger the template that is currently loaded.
            if o.canStimulate
                if o.fake
                    disp('Start Stim');
                else
                    ret = MatNICStartStimulation(o.sock);
                    o.checkRet(ret,'Trigger');
                end
            end
        end
        
        function stop(o)
            % Stop the current template running
            if o.fake
                disp('Stimulation stopped');
            else
                ret = MatNICAbortStimulation(o.sock);
            end
        end
                
        function impedance(o)
            % Measure and store impedance.
            if o.fake
                impedance = rand;
            else
                [ret,impedance] = MatNICGetImpedance(o.sock);
                o.checkRet(ret,'Impedance')
            end
            o.z = cat(1,o.z,impedance);
            o.zTime = cat(1,o.zTime,now);
        end
        
    end
    methods (Access= protected)
        function checkRet(o,ret,msg)
            % Check a return value and display a message if something is
            % wrong.
            if ret<0
                error(['StarStim failed: Stauts ' o.status ':  ' num2str(ret) ' ' msg]);
            end
        end
        
        function ok = canStimulate(o)
            % Check status to see if we can stimulate now.
            if o.fake
                ok = true;
            else
                ok = strcmpi(o.status,'CODE_STATUS_STIMULATION_READY');
            end
        end        
    end
    
    
end