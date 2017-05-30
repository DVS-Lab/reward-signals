function [point_mat, thresh_points] = simulate_points3()

Nperms = 10000;

ntrials = 160;

d = load('Vwalk_all_v1.mat');
soc_win = [ones(1,ntrials/2) zeros(1,ntrials/2)];
point_mat = zeros(Nperms,1);
for p = 1:Nperms
    points = 0;
        soc_win = Shuffle(soc_win);
        deck1 = d.data(21:end,1);
        deck2 = d.data(21:end,2);
        outcomes = [deck1 deck2 soc_win'];
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
