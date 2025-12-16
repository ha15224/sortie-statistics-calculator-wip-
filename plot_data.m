% 1: bucket without avg line
% 2: bucket with avg line
% 3: fs sunk average
% 4: boss rating without avg line
% 5: boss rating with avg line
% 6: repair cost
% 7: mogami boss mvp rate
% 8: retreat rate

% plotindex = 2; % bucket
% plotindex = 3; % fs sunk
% plotindex = 5; % boss rating
% plotindex = 6; % repair cost
plotindex = 7; % mogami boss mvp
% plotindex = 8; % retreat rate

if plotindex == 1

cumbucket = 0;
cumbuckaverage = zeros(count,1);
for i = 1:count
    cumbucket = cumbucket + tally34(i).bucket;
    cumbuckaverage(i) = cumbucket/i;
end
% semilogx(cumbuckaverage)
plot(cumbuckaverage)
ylim([0,max(cumbuckaverage)+0.5])
grid on
xlabel('trials')
ylabel('observed average bucket')


elseif plotindex == 2


% raw bucket values
b = [tally34.bucket]';   % column vector
n = numel(b);
% cumulative mean
cmean = cumsum(b) ./ (1:n)';
% cumulative standard deviation
csd = arrayfun(@(k) std(b(1:k)), 1:n)';
% standard error
se = csd ./ sqrt((1:n)');
% 95% confidence interval
z = 1.96;
upper = cmean + z*se;
lower = cmean - z*se;
% plot
figure; hold on;
% Plot the cumulative mean (save handle)
hMean = plot(cmean,'LineWidth',1.5);
% Plot the confidence interval band (save handle)
hCI = fill([1:n, fliplr(1:n)], [upper', fliplr(lower')], ...
           [0.8 0.8 1], 'FaceAlpha',0.3, 'EdgeColor','none');
ylim([0 2])
% xlim([0 3000])
xlabel('Trials');
ylabel('Observed average bucket');
yline(0.711202136,'--','LineWidth',1.0);
grid on;
legend([hMean, hCI], {'Observed average','95% confidence interval'});



elseif plotindex == 3

cumfssunk = 0;
cumfssunkaverage = zeros(count,1);
% Allocate Wilson bounds
wilson_low  = zeros(count,1);
wilson_high = zeros(count,1);
z = 1.96;   % 95% confidence
for i = 1:count
    % cumulative successes
    cumfssunk = cumfssunk + tally34(i).fssunk;
    p = cumfssunk / i;       % cumulative proportion
    % Wilson interval calculation
    denom = 1 + z^2/i;
    center = (p + (z^2)/(2*i)) / denom;
    radius = (z * sqrt( (p*(1-p))/i + z^2/(4*i^2) )) / denom;
    wilson_low(i)  = center - radius;
    wilson_high(i) = center + radius;
    cumfssunkaverage(i) = p;
end
% Plot
figure; hold on;
% Mean curve
plot(cumfssunkaverage, 'LineWidth', 1.5);
% Wilson confidence band
fill([1:count, fliplr(1:count)], ...
     [wilson_high' , fliplr(wilson_low')], ...
     [0.8 0.8 1], 'FaceAlpha',0.3, 'EdgeColor','none');
ylim([0, max(cumfssunkaverage) + 0.1]);
grid on;
xlabel('Trials');
ylabel('Observed FS sinking rate');
% reference line
yline(0.535230219,'--','LineWidth',1.0);
ylim([0,1])
legend('Flagship sunk rate','95% Wilson confidence interval','Location','best');
hold off;



elseif plotindex == 4


ratingstotal = zeros(count+1,4);
rankrate = zeros(count,4);
reachcount = 0;
for i = 1:count
    rank_temp = zeros(1,4);
    if tally34(i).bossrank ~= 0 
        reachcount = reachcount + 1;
        rank_temp(tally34(i).bossrank) = 1;
    end
    ratingstotal(i+1,:) = ratingstotal(i,:) + rank_temp;
    rankrate(i,:) = ratingstotal(i+1,:)/reachcount;
end
semilogx(rankrate(:,1), 'Color', [0.7 0.7 0]);      % C → yellow
hold on
semilogx(rankrate(:,2), 'Color', [1 0.5 0]);    % B → orange
semilogx(rankrate(:,3), 'Color', [1 0 0]);      % A → red
semilogx(rankrate(:,4), 'Color', [1 0.843 0]);  % S → gold  (RGB for gold)
% plot(rankrate(:,1), 'Color', [0.7 0.7 0]);      % C → yellow
% hold on
% plot(rankrate(:,2), 'Color', [1 0.5 0]);    % B → orange
% plot(rankrate(:,3), 'Color', [1 0 0]);      % A → red
% plot(rankrate(:,4), 'Color', [1 0.843 0]);  % S → gold  (RGB for gold)
hold off
xlabel('trials')
ylabel('cumulative boss rank')
legend('C-rank','B-rank','A-rank','S-rank')
grid on


elseif plotindex == 5



% --- Configuration ---
alpha = 0.05;                    % 95% CI
z = norminv(1 - alpha/2);        % z = 1.96
% --- Storage ---
ratingstotal = zeros(count+1,4);
rankrate     = zeros(count,4);
lowerW       = zeros(count,4);
upperW       = zeros(count,4);
reachcount = 0;
for i = 1:count
    % Convert rank to indicator vector
    rank_temp = zeros(1,4);
    if tally34(i).bossrank ~= 0
        reachcount = reachcount + 1;
        rank_temp(tally34(i).bossrank) = 1;
    end
    % Update cumulative counts and cumulative MLE estimate
    ratingstotal(i+1,:) = ratingstotal(i,:) + rank_temp;
    M = ratingstotal(i+1,:);     % counts for each category
    N = reachcount;              % total valid trials so far
    if N == 0
        continue
    end
    % Compute Wilson intervals for each category
    for k = 1:4
        m = M(k);
        p = m / N;
        % Wilson center and margin
        denom  = 1 + z^2 / N;
        center = (p + (z^2)/(2*N)) / denom;
        margin = (z / denom) * sqrt( (p*(1-p))/N + (z^2)/(4*N^2) );
        % Store results
        rankrate(i,k) = p;
        lowerW(i,k)   = max(0, center - margin);
        upperW(i,k)   = min(1, center + margin);
    end
end
x = 1:count;
figure; hold on;
% Colors (same as original code)
colC = [0.7 0.7 0];       % C → yellow
colB = [1   0.5 0];       % B → orange
colA = [1   0   0];       % A → red
colS = [1   0.843 0];     % S → gold
% --- Helper for CI shading ---
plotCI = @(x,low,up,col) fill([x fliplr(x)], [low' fliplr(up')], ...
                               col, 'FaceAlpha', 0.15, 'EdgeColor', 'none');
% --- S-rank (category 4) ---
plotCI(x, lowerW(:,4), upperW(:,4), colS);
plot(x, rankrate(:,4), 'Color', colS, 'LineWidth', 1.5);
% --- A-rank (category 3) ---
plotCI(x, lowerW(:,3), upperW(:,3), colA);
plot(x, rankrate(:,3), 'Color', colA, 'LineWidth', 1.5);
% --- B-rank (category 2) ---
plotCI(x, lowerW(:,2), upperW(:,2), colB);
plot(x, rankrate(:,2), 'Color', colB, 'LineWidth', 1.5);
% --- C-rank (category 1) ---
plotCI(x, lowerW(:,1), upperW(:,1), colC);
plot(x, rankrate(:,1), 'Color', colC, 'LineWidth', 1.5);
yline(0.313754733,'--','LineWidth',1.0);
yline(0.38270722,'-','LineWidth',1.0);
yline(0.301402074,':','LineWidth',1.0);
yline(0.002480504,'-.','LineWidth',1.0);
hold off;
ylim([0,1]);
xlabel('Trials');
ylabel('Observed boss rank');
legend('S 95% CI','S','A 95% CI','A','B 95% CI','B','C 95% CI','C','S-rank sim data','A-rank sim data','B-rank sim data','C-rank sim data', 'Location','best');
% title('Cumulative Rank Probabilities with Wilson 95% Confidence Bands');
grid on;


elseif plotindex == 6

fuellog  = [tally34.repairfuel];
steellog = [tally34.repairsteel];

count = length(fuellog);

% cumulative mean
fuel_avg  = cumsum(fuellog).'  ./ (1:count).';
steel_avg = cumsum(steellog).' ./ (1:count).';

% cumulative SD
fuel_sd  = arrayfun(@(k) std(fuellog(1:k)),  1:count).';
steel_sd = arrayfun(@(k) std(steellog(1:k)), 1:count).';

% standard error
fuel_se  = fuel_sd  ./ sqrt((1:count).');
steel_se = steel_sd ./ sqrt((1:count).');

z = 1.96;

% 95% CI
fuel_upper  = fuel_avg  + z * fuel_se;
fuel_lower  = fuel_avg  - z * fuel_se;

steel_upper = steel_avg + z * steel_se;
steel_lower = steel_avg - z * steel_se;

% ====== Plot ======
figure; hold on;

% plot means
hFuel  = plot(fuel_avg,  'LineWidth', 1.5);
hSteel = plot(steel_avg, 'LineWidth', 1.5);

% shaded CI (fuel)
fill([1:count, fliplr(1:count)], ...
     [fuel_upper' fliplr(fuel_lower')], ...
     [0.8 0.9 1], 'FaceAlpha', 0.3, 'EdgeColor', 'none');

% shaded CI (steel)
fill([1:count, fliplr(1:count)], ...
     [steel_upper' fliplr(steel_lower')], ...
     [1 0.85 0.85], 'FaceAlpha', 0.3, 'EdgeColor', 'none');
yline(27.69828845,'--','LineWidth',1.0);
yline(52.2800885,'-.','LineWidth',1.0);
xlabel('Trials');
ylabel('Observed average repair cost');
legend('Fuel average','Steel average','Fuel 95% CI','Steel 95% CI', 'Fuel sim data','Steel sim data', 'Location','best');
grid on;

ylim([0, max([fuel_upper; steel_upper]) + 10]);


hold off;





elseif plotindex == 7

mogbossmvp = [];
for i = 1:count
   if tally34(i).reached == 1
        if tally34(i).data.battles{2, 1}.mvp == 6
            mogbossmvp = [mogbossmvp;1];
        else
            mogbossmvp = [mogbossmvp;0];
        end
   end
end
data = mogbossmvp(:);   % ensure column vector
count = length(data);
cum_success = 0;
p_cum       = zeros(count,1);
wilson_low  = zeros(count,1);
wilson_high = zeros(count,1);
z = 1.96;   % 95% confidence
for i = 1:count
    cum_success = cum_success + data(i);
    p = cum_success / i;        % cumulative proportion
    % Wilson interval
    denom  = 1 + z^2/i;
    center = (p + z^2/(2*i)) / denom;
    radius = (z * sqrt( p*(1-p)/i + z^2/(4*i^2) )) / denom;
    wilson_low(i)  = center - radius;
    wilson_high(i) = center + radius;
    p_cum(i) = p;
end
% ==== Plot ====
figure; hold on;
% plot cumulative mean
plot(p_cum,'LineWidth',1.5);
% fade Wilson CI
fill([1:count, fliplr(1:count)], ...
     [wilson_high' , fliplr(wilson_low')], ...
     [0.8 0.9 1], 'FaceAlpha',0.3, 'EdgeColor','none');
yline(0.821448542,'--','LineWidth',1.0);
xlabel('Trials');
ylabel('Observed mogami MVP rate');
legend('Observed MVP rate','95% Wilson CI','Mogami MVP sim data','Location','best');

grid on;
ylim([0,1]);
hold off;


elseif plotindex == 8

retreatflag = zeros(count,1);
for i = 1:count
   if tally34(i).reached == 1
       retreatflag(i) = 0;
   else
       retreatflag(i) = 1;
   end
end

data = retreatflag(:);   % ensure column vector
count = length(data);
cum_success = 0;
p_cum       = zeros(count,1);
wilson_low  = zeros(count,1);
wilson_high = zeros(count,1);
z = 1.96;   % 95% confidence
for i = 1:count
    cum_success = cum_success + data(i);
    p = cum_success / i;        % cumulative proportion
    % Wilson interval
    denom  = 1 + z^2/i;
    center = (p + z^2/(2*i)) / denom;
    radius = (z * sqrt( p*(1-p)/i + z^2/(4*i^2) )) / denom;
    wilson_low(i)  = center - radius;
    wilson_high(i) = center + radius;
    p_cum(i) = p;
end
% ==== Plot ====
figure; hold on;
% plot cumulative mean
plot(p_cum,'LineWidth',1.5);
% fade Wilson CI
fill([1:count, fliplr(1:count)], ...
     [wilson_high' , fliplr(wilson_low')], ...
     [0.8 0.9 1], 'FaceAlpha',0.3, 'EdgeColor','none');
yline(0.041375383,'--','LineWidth',1.0);
xlabel('Trials');
ylabel('Observed retreat rate');
legend('Retreat rate average','95% Wilson CI','Retreat sim data','Location','best');

grid on;
ylim([0,0.1]);
hold off;

end
