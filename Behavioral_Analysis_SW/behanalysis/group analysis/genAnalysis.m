filename = 'alldata.mat';
data = load(filename);
data = data.new;

numsub = size(data,2);
% c = [];
% pe = [];
% soc_win = [];
% is_catch = [];
% rating = [];
% mu = [];
% sigma = [];

% for i = 1:numsub
%     c = [c;data(i).c'];
%     pe = [pe;data(i).pe];
%     soc_win = [soc_win;data(i).soc_win];
%     is_catch = [is_catch;data(i).is_catch];
%     rating = [rating;data(i).rating];
% end


subjcode = [1001:1004,1006:1028];

for s = 1:numsub
    temp = data(s);
    numtrials = temp.N;
    
    % derive basics
    choice = temp.c;
    pe = temp.pe;
    info = nan(numtrials,1);
    pattern = info;
    %mu1 = temp.mu(:,1);
    %mu2 = temp.mu(:,2);
    %mu3 = temp.mu(:,3);
    %sigma1 = temp.sigma(:,1);
    %sigma2 = temp.sigma(:,2);
    sigma3 = temp.sigma(:,3);
    %r = temp.r;
    
    first = choice(1);
    if ~isnan(first)
        pattern(1) = 0;
    else
        pattern(1) = 1;
        choice(1) = 0;
    end
    
    for i = 2:length(choice)
        if isnan(choice(i))
           choice(i) = choice(i-1);
        end
        pattern(i) = abs(choice(i) - choice(i-1));
        
    end
    
    for i = 1:length(pe)
        PE = abs(pe(i));
        SIGMA = sigma3(i+1);
        info(i) = any(PE>SIGMA);
    end
    
    inter = pattern(2:end);
    inter(inter>0) = 3;
    inter(inter==0) = 1;
    inter(inter==3) = 0;
    pattern = [pattern(1);inter];
    aff = temp.soc_win;
    word = temp.word;
    rating = temp.rating;
    is_catch = temp.is_catch;
    
    summary.choice = pattern;
    summary.info = info;
    summary.aff = aff;
    summary.word = word;
    summary.rating = rating;
    summary.is_catch = is_catch;
    summary.partner = temp.partner;
    summary.pe = temp.pe;
    
    fname = ['gen' num2str(subjcode(s))];
    save(fname,'summary');
end
    