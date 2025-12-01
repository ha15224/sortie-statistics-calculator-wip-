% % replace with your own kc3 file or equivalent method of sortie importing
% jsonText = fileread('KC3sortie_はあちゃま_20251130.json');
% jsonText = fileread('KC3sortie_はあちゃま_20251201.json');
% data = jsondecode(jsonText);


% todo list
% 3-4 boss runs are only valid when vanguard selected at all nodes
% 3-4 retreats are counted as 1 bucket

% buckets are counted in a separate function
% if night battle exists buckets should be counted at end of NB

N = numel(fieldnames(data));

tally34 = struct();

% t_0 = 1.764507713000000e+09;

s_start = 15625;

count = 0;

for i = s_start:N
fld = sprintf('s%d', i);   % constructs 's15660', 's15661', ...
if isfield(data, fld)
dat = data.(fld);   % access data.sXXXXX.world
if dat.world == 3 && dat.mapnum == 4
    if length(dat.battles) == 2
        if dat.battles{1, 1}.data.api_formation(1) == 6 && dat.battles{2, 1}.data.api_formation(1) == 6
            count = count + 1;
            tally34(count).data = dat;
            tally34(count).reached = 1;
        end
    else
        count = count + 1;
        tally34(count).data = dat;
        tally34(count).reached = 0;
    end
end
end
end


for i = 1:length(tally34)
    tally34(i).id = tally34(i).data.id;
    if tally34(i).reached == 1
        [tally34(i).bucket,tally34(i).hpspercentage] = countbucket(tally34(i).data);
        tally34(i).fssunk = enemyfssunk(tally34(i).data);
        tally34(i).bossrank = ratings(tally34(i).data);
    else
        tally34(i).bucket = 1;
        tally34(i).fssunk = 0;
        tally34(i).bossrank = 0;
    end
end





