clear;
close all;

t = 180;
v = zeros(t,2);
decay = 0.9836;
%decay = 0.95;

theta = 50;
driftsigma = 2.8;

v(1,1) = round(normrnd(theta,4));
v(1,2) = round(normrnd(theta,4));

data = {};
count = 0;
valuediff = 30;
mintrials = 2;
vmin = 1;
vmax = 100;
go = 1;
while go
    for i = 1:t-1
        v1 = round(decay*(v(i,1) - theta) + theta + normrnd(0,driftsigma));
        v2 = round(decay*(v(i,2) - theta) + theta + normrnd(0,driftsigma));
        if v1 > vmax; v1 = vmax; elseif v1 < vmin; v1 = vmin; end
        if v2 > vmax; v2 = vmax; elseif v2 < vmin; v2 = vmin; end
        v(i+1,1) = v1;
        v(i+1,2) = v2;
    end
    
    
    idx1 = find((v(:,1)-v(:,2)) > valuediff);
    idx2 = find((v(:,1)-v(:,2)) < -valuediff);
    if ~isempty(idx1) && ~isempty(idx2)
        x1d = [diff(idx1) == 1; 0];
        numcells = sum(x1d==0);
        out1 = cell(1,numcells);
        indends = find(x1d == 0);
        ind = 1;
        for k = 1:numcells
            out1{k} = idx1(ind:indends(k));
            ind = indends(k)+1;
        end
        x2d = [diff(idx2) == 1; 0];
        numcells = sum(x2d==0);
        out2 = cell(1,numcells);
        indends = find(x2d == 0);
        ind = 1;
        for k = 1:numcells
            out2{k} = idx2(ind:indends(k));
            ind = indends(k)+1;
        end
        xx = corr(v);
        if (length(out1) > 1) && (length(out2) > 1) && (abs(xx(1,2)) < 0.2)
            i1_count = 0;
            for i1 = 1:length(out1)
                if length(out1{i1}) > mintrials
                    i1_count = i1_count + 1;
                end
            end
            i2_count = 0;
            for i2 = 1:length(out2)
                if length(out2{i2}) > mintrials
                    i2_count = i2_count + 1;
                end
            end
            
            if i1_count > 1 && i2_count > 1
                data = v;
                figure,plot(v)
                go = 0;
            end
        end
    end
end

%save('Vwalk_all_v1.mat','data')

