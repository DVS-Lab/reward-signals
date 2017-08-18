function lik = WSLSlik(x,data)
    
    %Choice: 1 = deck1; 2 = deck2; 3 = deck3
    %Outcome: 0, 1, 2, 3
    %data = [ decision(:,1), outcome(:,1)];

    
    % standard WSLS: 2 parameters:
	 p_s = x(1); % p_win|stay
	 p_l = x(2); % p_lose|shift
     
	%initialization

     N = data.N;
     p = 0.5*ones(1,2);
     lik = 0;
     
for trialnum = 1:N
    
    c = data.c(trialnum);
    r = data.r(trialnum);
	if trialnum == 1
        r_pre = 0;
    else
        r_pre = data.r(trialnum-1);
    end
	%if trialnum == 1
	   
    if c == 1 || c == 11 %deck1 action
      data.c(trialnum) = 1;
      c = 1;
      lik = lik + log(p(c));
      
      if r > r_pre || r == r_pre
			 p(c) = p_s;
			 p(3-c) = 1 - p_s; 
	  else
			 p(c) = 1 - p_l;
			 p(3-c) = p_l; 
      end
    
	elseif c == 2 || c == 22 %deck1 action
      data.c(trialnum) = 2;
      c = 2;
      lik = lik + log(p(c));
      
      if r > r_pre || r == r_pre
			 p(c) = p_s;
			 p(3-c) = 1 - p_s; 
	  else
			 p(c) = 1 - p_l;
			 p(3-c) = p_l; 
      end
    end
    
             
    
    
end

end    
