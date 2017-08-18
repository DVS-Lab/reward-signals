% win-stay-lose-shift model fitting:

% probability of stay-win
% r->reward, t->current trialnum, c->choice(1|2 for different options)
% 2 parameters: p_winstay, p_lossshift

c = choice(t-1);

if r(t-1)>r(t-2) 
   p(c) = p_winstay;
   p(3-c) = 1 - p_winstay;
elseif r(t-1)<r(t-2) 
   p(c) = 1-p_lossshift;
   p(3-c) = p_lossshift;
end


% win-stay-lose-shift + learning model:
% 4 parameters: p_winstay0, p_lossshift0, theta_winstay, theta_lossshift

c = choice(t-1);

if r(t-1)>r(t-2) 
   p_winstay = p_winstay + theta_winstay*(1 - p_winstay);
   p_lossshift = (1 - theta_lossshift)*p_lossshift;
   p(c) = p_winstay;
   p(3-c) = 1 - p_winstay;
   
elseif r(t-1)<r(t-2) 
   p_lossshift = p_lossshift + theta_lossshift*(1 - p_lossshift);
   p_winstay = (1 - theta_winstay)*p_winstay;
   p(c) = 1-p_lossshift;
   p(3-c) = p_lossshift;
   
end