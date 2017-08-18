clear;
close all;

t = 40;
v = zeros(t,2);
decay = 0.9836;

theta = 50;
driftsigma = 2.8;
v(1,1) = round(normrnd(theta,4));
v(1,2) = round(normrnd(theta,4));
%v1 = decay*(v(i,1) - theta) + theta + normrnd(0,driftsigma)

data = {};
count = 0;
valuediff = 25;
mintrials = 3;
while length(data) < 4
    for i = 1:t-1
        v1 = round(decay*(v(i,1) - theta) + theta + normrnd(0,driftsigma));
        v2 = round(decay*(v(i,2) - theta) + theta + normrnd(0,driftsigma));
        if v1 > 99; v1 = 99; elseif v1 < 1; v1 = 1; end
        if v2 > 99; v2 = 99; elseif v2 < 1; v2 = 1; end
        v(i+1,1) = v1;
        v(i+1,2) = v2;
    end
    v1_len = length(find((v(:,1)-v(:,2)) > valuediff));
    v2_len = length(find((v(:,1)-v(:,2)) < -valuediff));
    if v1_len > mintrials && v2_len > mintrials
        count = count + 1;
        data(count,1) = {v};
        figure,plot(v)
    end
end

save('Vwalks.mat','data')