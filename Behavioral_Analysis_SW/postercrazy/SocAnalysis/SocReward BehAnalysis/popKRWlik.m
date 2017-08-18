function logpo = popKRWlik(x,data)  
logpo = nan(length(data),1);

likfunc = @KRWlik;
    
    for s = 1:length(data)
        logpo(s) = likfunc(x,data);
    end
   
    logpo = sum(logpo);
end
