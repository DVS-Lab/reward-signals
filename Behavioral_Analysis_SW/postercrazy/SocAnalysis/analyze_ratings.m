function analyze_ratings()

maindir = pwd;
addpath(fullfile(maindir,'rw'));

try
    pos = {'interested','excited','attentive','strong' ...
        'enthusiastic','proud','alert','active','inspired','determined'};
    
    neg = {'distressed','upset','guilty','scared','hostile','jittery', ...
        'irritable','ashamed','nervous','afraid'};
    
    % is_catch(k) == 1 %inf only with rating
    
    blocks = 1:4;
    subjects = 601:605;
    
    %col1: inf_hi (hi PE), col2: inf_low (low PE), col3: aff_hi, col4: aff_low
    sub_data = zeros(length(subjects),4);
    for s = 1:length(subjects)
        subject = subjects(s);
        clear bigdata big_pe
        for r = 1:length(blocks)
            datadir = fullfile(maindir,'data',num2str(subject));
            load(fullfile(datadir,sprintf('%s_feedback_%d.mat',num2str(subject),r)))
            
            %get PEs
            choicedata = [data.Npoints; data.deckchoice]';
            %choicedata(choicedata(:,1)==0,:) = [];
            out = choicedata(:,1);
            dec = choicedata(:,2);
            
            alpha = 0.40;
            beta = 2;
            [~, ~, ~, pe_e] = runRW(dec, out, alpha, beta);
            
            if exist('big_pe','var')
                big_pe = [big_pe pe_e];
            else
                big_pe = pe_e;
            end
            
            if exist('bigdata','var')
                bigdata = [bigdata data];
            else
                bigdata = data;
            end
        end
        
        ratingdata = [bigdata.is_catch; bigdata.rating; bigdata.soc_win]';
        ratingdata = [ratingdata big_pe'];
        ratings = ratingdata;
        ratings(~ratingdata(:,2) | ratingdata(:,4)==999,:) = [];
        
        words = {bigdata.word}';
        words(~ratingdata(:,2) | ratingdata(:,4)==999,:) = [];
        
        reverse = 1 + (-2 * ismember(words,neg));
        scoredratings = ratings(:,2) .* reverse;
        
        sub_data(s,1) = mean(scoredratings( ratings(:,1)==1 & ratings(:,4)>median(abs(ratings(:,4))) ));
        sub_data(s,2) = mean(scoredratings( ratings(:,1)==1 & ratings(:,4)<median(abs(ratings(:,4))) ));
        
        sub_data(s,3) = mean(scoredratings( ratings(:,1)==2 & ratings(:,3) ));
        sub_data(s,4) = mean(scoredratings( ratings(:,1)==2 & ~ratings(:,3) ));
    end
    mean(sub_data)
    std(sub_data)/sqrt(5)
    keyboard
    
catch ME
    disp(ME.message)
    keyboard
end

