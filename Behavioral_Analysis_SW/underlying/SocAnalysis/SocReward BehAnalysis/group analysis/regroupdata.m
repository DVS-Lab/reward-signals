function sub_data = regroupdata(all)

maindir = pwd;
% addpath(fullfile(maindir,'rw'));
    param = load('indi.mat');
    param = param.results.x;
    param_pop = param(1:5);
    betas = param(6:end);
    
    
    subjects = [1001:1004,1006:1028];
    numSub = length(subjects);
    blockindx = [ones(numSub,1),4*ones(numSub,1),true(numSub,1)];
    
    %
    blockindx(1,2) = 2;
    blockindx([1,2,3,5],3) = false;
    
    %col1: inf_hi (hi PE), col2: inf_low (low PE), col3: aff_hi, col4: aff_low
    % sub_data = zeros(length(subjects),4);
    
    %col1: inf_hi (hi PE), col2: inf_low (low PE), col3: aff_hi, col4: aff_low

    for s = 1:length(subjects)
        subject = subjects(s);
        clear Data out dec soc_win is_catch word rating
        out = nan;
        dec = nan;
        soc_win = nan;
        is_catch = nan;
        word = nan;
        rating = nan;
        
        blocks = blockindx(s,1):blockindx(s,2);
        for r = 1:length(blocks)
            datadir = fullfile(maindir,'data',num2str(subject));
            load(fullfile(datadir,sprintf('%s_feedback_%d.mat',num2str(subject),r)))
            
            %get PEs
            choicedata = [data.Npoints; data.deckchoice]';
            %choicedata(choicedata(:,1)==0,:) = [];
            out = [out;choicedata(:,1)];
            dec = [dec;choicedata(:,2)];
            
            ratingdata = [data.soc_win;data.is_catch;data.rating]';
            soc_win = [soc_win; ratingdata(:,1)];
            is_catch = [is_catch;ratingdata(:,2)];
            %word = [word; ratingdata(:,3)];
            rating = [rating; ratingdata(:,end)];
        end
            
            out = out(2:end);
            dec = dec(2:end);
            soc_win = soc_win(2:end);
            is_catch = is_catch(2:end);
            %word = word(2:end);
            rating = rating(2:end);
        if blockindx(s,3) == true
        %%%%%practice
            load(fullfile(datadir,sprintf('%s_feedback_prac.mat',num2str(subject))));
            choicedata = [data.Npoints; data.deckchoice]';
            pracout = choicedata(:,1);
            pracdec = choicedata(:,2);
            ratingdata = [data.soc_win;data.is_catch;data.rating]';
            pracsoc_win = ratingdata(:,1);
            pracis_catch = ratingdata(:,2);
            %pracword = [word; ratingdata(:,3)];
            pracrating = ratingdata(:,end);
    
            out = [pracout;out];
            dec = [pracdec;dec];
            soc_win = [pracsoc_win;soc_win];
            is_catch = [pracis_catch;is_catch];
            %word = [pracword;word];
            rating = [pracrating;rating];
        end
            clear Data
            Data.c = dec;
            Data.r = out;
            Data.N = size(Data.c,1);
            Data.soc_win = soc_win;
            Data.is_catch = is_catch;
            %Data.word = word;
            Data.rating = rating;
            
            Data.param = param_pop;
            Data.beta = betas(s);
            model = getpe(Data,s);
            Data.pe = model.dt;
            Data.c = model.c;
            Data.mu = model.mu;
            Data.sigma = model.sigma;
            Data.r = model.r;
            sub_data(s) = Data;
       
    end

    

end

