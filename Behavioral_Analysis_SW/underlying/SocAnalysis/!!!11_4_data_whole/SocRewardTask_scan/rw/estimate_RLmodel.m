function [loglike_e, alpha_e, beta_e, pe_e]  = estimate_RLmodel(decision, outcome, alpha, beta )

try
    
    %Choice: 1 = deck1; 2 = deck2; 3 = deck3
    %Outcome: 0, 1, 2, 3
    data = [ decision(:,1), outcome(:,1)];
    
    %Standard RW: 2 Parameter
    
    %Free parameters
    %alpha = xpar(1);
    %beta = xpar(2);
    
    
    %Set initial values
    % can do better for initial value = first real value (primacy) http://www.ncbi.nlm.nih.gov/pubmed/22924882
    % maybe set to average value of the deck
    vD1(1) = 1.5;
    vD2(1) = 1.5;
    vD3(1) = 1.5;
    pD1(1) = 1/3;
    pD2(1) = 1/3;
    pD3(1) = 1/3;
    loglike_e = 0;
    pe(1) = 0;
    
    for trialnum = 1:size(data,1)
        
        
           
        
        %Update log-likelihood -- switching to max loglikelihood
        if data(trialnum,1) == 1
            loglike_e = loglike_e + log(pD1(trialnum));
        elseif data(trialnum,1) == 2
            loglike_e = loglike_e + log(pD2(trialnum));
        elseif data(trialnum,1) == 3
            loglike_e = loglike_e + log(pD3(trialnum));
        end
        
        if data(trialnum,1) == 1 %deck1 action
            
            pe(trialnum) = data(trialnum,2) - vD1(trialnum);
            vD1(trialnum + 1) = vD1(trialnum) + alpha * pe(trialnum);
            vD2(trialnum + 1) = vD2(trialnum); %if not selected continue value to nxt trial
            vD3(trialnum + 1) = vD3(trialnum); %if not selected continue value to nxt trial
            
        elseif data(trialnum,1) == 2 %deck2 action
            
            pe(trialnum) = data(trialnum,2) - vD2(trialnum);
            vD2(trialnum + 1) = vD2(trialnum) + alpha * pe(trialnum);
            vD3(trialnum + 1) = vD3(trialnum); %if not selected continue value to nxt trial
            vD1(trialnum + 1) = vD1(trialnum); %if not selected continue value to nxt trial
            
        elseif data(trialnum,1) == 3 %deck3 action
            
            pe(trialnum) = data(trialnum,2) - vD3(trialnum);
            vD3(trialnum + 1) = vD3(trialnum) + alpha * pe(trialnum);
            vD1(trialnum + 1) = vD1(trialnum); %if not selected continue value to nxt trial
            vD2(trialnum + 1) = vD2(trialnum); %if not selected continue value to nxt trial
            
            
            
        end
        
        %Calculate probability using softmax
        pD1(trialnum + 1) = exp(vD1(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) + exp(vD3(trialnum+1)/beta) );
        pD2(trialnum + 1) = exp(vD2(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) + exp(vD3(trialnum+1)/beta) );
        pD3(trialnum + 1) = exp(vD3(trialnum+1)/beta) / ( exp(vD1(trialnum+1)/beta) + exp(vD2(trialnum+1)/beta) + exp(vD3(trialnum+1)/beta) );
        
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

