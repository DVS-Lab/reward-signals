function [loglike_e, alpha_e, beta_e, pe_e]  = runRW_fe(decision, outcome, alpha, beta, loglike_i )

try
    
    %Choice: 1 = deck1; 2 = deck2; 3 = deck3
    %Outcome: 0, 1, 2, 3
    data = [ decision(:,1), outcome(:,1)];

    
    %Standard RW: 2 Parameter
    
    %Free parameters
    %alpha = xpar(1);
    %beta = xpar(2);
    
    
    %Set initial values
    v1 = data(data(:,1)==1,2); %primacy
    v2 = data(data(:,1)==2,2);
    vD1(1) = v1(1);
    vD2(1) = v2(1);
    pD1(1) = 1/2;
    pD2(1) = 1/2;
    loglike_e = loglike_i;
    pe(1) = 0;
    
    
    for trialnum = 1:size(data,1)
        
        %Update log-likelihood -- switching to max loglikelihood
        if data(trialnum,1) == 1
            loglike_e = loglike_e + log(pD1(trialnum));
        elseif data(trialnum,1) == 2
            loglike_e = loglike_e + log(pD2(trialnum));
        end
        
        if data(trialnum,1) == 1 %deck1 action
            pe(trialnum) = data(trialnum,2) - vD1(trialnum);
            vD1(trialnum + 1) = vD1(trialnum) + alpha * pe(trialnum);
            vD2(trialnum + 1) = vD2(trialnum); %if not selected continue value to nxt trial
            %disp('action 1')
        elseif data(trialnum,1) == 2 %deck2 action
            pe(trialnum) = data(trialnum,2) - vD2(trialnum);
            vD2(trialnum + 1) = vD2(trialnum) + alpha * pe(trialnum);
            vD1(trialnum + 1) = vD1(trialnum); %if not selected continue value to nxt trial
            %disp('action 2')
        end
        
        %Calculate probability using softmax
        pD1(trialnum + 1) = exp(vD1(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) );
        pD2(trialnum + 1) = exp(vD2(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) );
        %pCir(trialnum + 1) = exp(vCir(trialnum+1)/beta) / ( exp(vDia(trialnum+1)/beta) + exp(vCir(trialnum+1)/beta));
        
    end
    %figure,plot(pD1,'r')
    %hold on
    %plot(pD2,'g')
    %plot(pD3,'b')
    %title(['beta is ' num2str(beta)])
    pe_e = pe;
    alpha_e = alpha;
    beta_e = beta;
catch ME
    disp(ME.message)
    keyboard;
end

