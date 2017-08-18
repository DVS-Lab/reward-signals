function [loglike_e, alpha_e, beta_e, pe_e]  = runRW(decision, outcome, alpha, beta )

try
    
    %Choice: 1 = deck1; 2 = deck2; 3 = deck3
    %Outcome: 0, 1, 2, 3
    data = [ decision(:,1), outcome(:,1)];
    
    %Standard RW: 2 Parameter
    
    %Free parameters
    %alpha = xpar(1);
    %beta = xpar(2);
    
    
    %Set initial values
    vD1(1) = 5;
    vD2(1) = 5;
    pD1(1) = 1/2;
    pD2(1) = 1/2;
    loglike_e = 0;
    pe(1) = 0;
    
    for trialnum = 1:size(data,1)
        
        %Update log-likelihood -- switching to max loglikelihood
        if data(trialnum,1) == 1
            loglike_e = loglike_e + log(pD1(trialnum));
        elseif data(trialnum,1) == 2
            loglike_e = loglike_e + log(pD2(trialnum));
        end
        
        
        if ~data(trialnum,1)
            pe(trialnum) = 999; %remove later
            vD1(trialnum + 1) = vD1(trialnum); %if not selected continue value to nxt trial
            vD2(trialnum + 1) = vD2(trialnum); %if not selected continue value to nxt trial
            pD1(trialnum + 1) = pD1(trialnum); %if not selected continue value to nxt trial
            pD2(trialnum + 1) = pD2(trialnum); %if not selected continue value to nxt trial
        else
            if data(trialnum,1) == 1 || data(trialnum,1) == 11 %deck1 action
                pe(trialnum) = data(trialnum,2) - vD1(trialnum);
                vD1(trialnum + 1) = vD1(trialnum) + alpha * pe(trialnum);
                vD2(trialnum + 1) = vD2(trialnum); %if not selected continue value to nxt trial
            elseif data(trialnum,1) == 2 || data(trialnum,1) == 22 %deck2 action
                pe(trialnum) = data(trialnum,2) - vD2(trialnum);
                vD2(trialnum + 1) = vD2(trialnum) + alpha * pe(trialnum);
                vD1(trialnum + 1) = vD1(trialnum); %if not selected continue value to nxt trial
            end
            %Calculate probability using softmax
            pD1(trialnum + 1) = exp(vD1(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) );
            pD2(trialnum + 1) = exp(vD2(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) );
            %pCir(trialnum + 1) = exp(vCir(trialnum+1)/beta) / ( exp(vDia(trialnum+1)/beta) + exp(vCir(trialnum+1)/beta));
        end
        
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

