filename = 'alldata.mat';
data = load(filename);
data = data.alldata;

numsub = size(data,2);
c = [];
pe = [];
soc_win = [];
is_catch = [];
rating = [];

for i = 1:numsub
    c = [c;data(i).c'];
    pe = [pe;data(i).pe];
    soc_win = [soc_win;data(i).soc_win];
    is_catch = [is_catch;data(i).is_catch];
    rating = [rating;data(i).rating];
end

pe(pe==0) = [];
pe_mean = mean(pe);
pe_std = std(pe,1);


%pe_abs = abs(pe);

pe_trials = zeros(length(pe),1);
pe_trials(find(abs(pe-pe_mean)>pe_std))=1;

subjcode = [1001:1004,1006:1028];

for s = 1:numsub
    temp = data(s);
    numtrials = temp.N;
    store = zeros(numtrials,3);
    choice = temp.c;
    pe = temp.pe;
    info = abs(temp.pe);
    info = info>temp.param(3);
    store(:,2) = pe;
    store(:,3) = info;
    
    
    c = choice(1);
    value = isnan(c);
    if value
        store(1,1) = 1;
    else
        store(1,1) = 0;
    end
    
    for t = 2:numtrials
        pre = choice(t-1);
        c = choice(t);
        value = isnan(c);
        if value
           store(t,1) = 1;
        else
           if ~isnan(pre) 
           store(t,1) = 1-abs(c-pre);
           else store(t,1) = 0;
           end
        end
    end
    summary = store;
    fname = ['summary' num2str(subjcode(s))];
    save(fname,'summary');
end
    
