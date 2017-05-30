function output = PAL_Models_dvs( subid, decision, outcome, min, max )

% This function will run a abstract computational model on Mathieu Roy's
% PAL Dataset separately for each subject.  Note that this script assumes
% that higher value is associated with less pain.
%
% USAGE:
% output = PAL_Models( 'ST', subid, decision, outcome, min, max)
%
% INPUTS:
% model         Type of model to run
% subid         Vector of subject ids
% decision      Matrix of subject decisions (trial X subject) 1 = Diamond; 2 = Circle
% outcome       Matrix of subject outcomes (trial x subject) 1 = pain; 0 = nopain
% min           Vector of mininum parameters for fmincon (must have value for each parameter)
% max           Vector of maximum parameters for fmincon (must have value for each parameter
%
% Written by Luke Chang 3/15/13

% PROGRAMMER NOTES:

sub = 1;

global TrialOut

%% Set optimization parameters

options = optimset(@fmincon);
options = optimset(options, 'TolX', 0.00001, 'TolFun', 0.00001, 'MaxFunEvals', 900000000, 'LargeScale','off');
%options = optimset('Algorithm','interior-point');

%% Estimate parameters using fmincon for each subject


subdataout = [];
TrialSubOut = [];

exitflag = 0;
count = 0;
while exitflag ~= 1
    disp(num2str(count))
    
    count = count + 1;
    %start low and then optimize from there
    if count > 1
%         %keyboard
%         if rand > .5
%             ipar = xpar + ceil(rand*10)*xpar;
%         else
%             ipar = xpar - ceil(rand*10)*xpar;
%         end
        ipar = rand(1,length(min)).* [1 count]; %pick random numbers for initial parameters
        
    else
        ipar = rand(1,length(min)).* [1 1]; %pick random numbers for initial parameters
    end
    
    %Choice: 1 = deck1; 2 = deck2; 3 = deck3
    %Outcome: 0, 1, 2, 3
    data = [subid(sub)*ones(length(decision),1), decision(:,1), outcome(:,sub)];
    
    %xpar = []; fval = []; exitflag = []; out = [];  %Initialize values to workspace
    
    [xpar, fval, exitflag, out]=fmincon(@ST, ipar, [], [], [], [], min, max, [], [], data);
    params(sub,1) = subid(sub);
    params(sub,2:length(xpar) + 1) = xpar; % alpha, beta
    params(sub,length(xpar) + 2) = fval; %what exactly is this? the minimum of the function
    params(sub,length(xpar) + 3) = out.iterations;
    params(sub,length(xpar) + 4) = 2 * length(ipar) + fval; %AIC-smaller is better - LLE should be Negative see Doll et al Brain Research
    params(sub,length(xpar) + 5) = 2 * fval + length(ipar) * log(size(decision,1)); %BIC-Smaller is better - LLE should be negative see Doll et al Brain Research
    
    %Display the subject being processed
    disp([ 'Subject ' num2str(subid(sub)) ': ' num2str(exitflag) ])
    TrialSubOut = TrialOut;
end

output.params = params;
output.trial = TrialSubOut;
keyboard

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Models Below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function LogLike = ST(xpar, data)
        %Standard RW: 2 Parameter
        
        %Free parameters
        alpha = xpar(1);
        beta = xpar(2);
        try
            %Set initial values
            vD1(1) = 0;
            vD2(1) = 0;
            vD3(1) = 0;
            pD1(1) = 1/3;
            pD2(1) = 1/3;
            pD3(1) = 1/3;
            LogLike = 0;
            pe(1) = 0;
        catch ME
            disp(ME.message)
            keyboard
        end
        for trialnum = 1:size(data,1)
            
            %Update log-likelihood
            if data(trialnum,2) == 1
                LogLike = LogLike - log(pD1(trialnum));
            elseif data(trialnum,2) == 2
                LogLike = LogLike - log(pD2(trialnum));
            elseif data(trialnum,2) == 3
                LogLike = LogLike - log(pD3(trialnum));
            end
            
            %Update expected values
            if data(trialnum,2) == 1 %deck1 action
                
                pe(trialnum) = data(trialnum,3) - vD1(trialnum);
                vD1(trialnum + 1) = vD1(trialnum) + alpha * pe(trialnum);
                vD2(trialnum + 1) = vD2(trialnum); %if not selected continue value to nxt trial
                vD3(trialnum + 1) = vD3(trialnum); %if not selected continue value to nxt trial
                
            elseif data(trialnum,2) == 2 %deck2 action
                
                pe(trialnum) = data(trialnum,3) - vD2(trialnum);
                vD2(trialnum + 1) = vD2(trialnum) + alpha * pe(trialnum);
                vD3(trialnum + 1) = vD3(trialnum); %if not selected continue value to nxt trial
                vD1(trialnum + 1) = vD1(trialnum); %if not selected continue value to nxt trial
                
            elseif data(trialnum,2) == 3 %deck3 action
                
                pe(trialnum) = data(trialnum,3) - vD3(trialnum);
                vD3(trialnum + 1) = vD3(trialnum) + alpha * pe(trialnum);
                vD1(trialnum + 1) = vD1(trialnum); %if not selected continue value to nxt trial
                vD2(trialnum + 1) = vD2(trialnum); %if not selected continue value to nxt trial
                
            end
            
            %Calculate probability using softmax
            %pDia(trialnum + 1) = exp(vDia(trialnum + 1) / beta) / (exp(vDia(trialnum + 1) / beta) + exp(vCir(trialnum + 1) / beta));
            %pCir(trialnum + 1) = exp(vCir(trialnum + 1) / beta) / (exp(vDia(trialnum + 1) / beta) + exp(vCir(trialnum + 1) / beta));
            
            pD1(trialnum + 1) = exp(vD1(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) + exp(vD3(trialnum+1)/beta) );
            pD2(trialnum + 1) = exp(vD2(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) + exp(vD3(trialnum+1)/beta) );
            pD3(trialnum + 1) = exp(vD3(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) + exp(vD3(trialnum+1)/beta) );
            
        end
        
        %Output Trial data as global - not ideal, but don't want to mess with minimization
        TrialOut = [data, (1:size(data,1))', vD1(1:size(data,1))', vD2(1:size(data,1))', vD3(1:size(data,1))', pD1(1:size(data,1))', pD2(1:size(data,1))', pD3(1:size(data,1))', pe'];
    end

end

