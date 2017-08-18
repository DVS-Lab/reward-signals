function thresh_points = simulate_points()

Nperms = 1000;
Nruns = 4;

ntrials = 44 * Nruns;

deck1 = zeros(ntrials,1);
deck2 = zeros(ntrials,1);
soc_win = [ones(1,ntrials/2) zeros(1,ntrials/2)];

point_mat = zeros(Nperms,1);
for p = 1:Nperms
    
    for t = 1:ntrials
        p1 = round(normrnd(4,1.25));
        p2 = round(normrnd(6,1.25));
        if p1 <= 0; p1 = 1; elseif p1 > 9; p1 = 9; end
        if p2 <= 0; p2 = 1; elseif p2 > 9; p2 = 9; end
        deck1(t,1) = p1;
        deck2(t,1) = p2;
    end
    soc_win = Shuffle(soc_win);
    
    points = 0;
    outcomes = [deck1 deck2 soc_win'];
    %keyboard
    for t = 1:length(outcomes)
        if outcomes(t,3)
            sim_choices = randperm(2);
            points = points + outcomes(t,sim_choices(1));
        end
    end
    point_mat(p,1) = points;
end
figure,hist(point_mat,50);
thresh_points = prctile(point_mat,95);
vline(thresh_points);

    
