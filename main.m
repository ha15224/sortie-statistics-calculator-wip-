% raw = fileread("ayu.txt");
% outer = jsondecode(raw);
% % outer is an array, so index outer(1)
% for i = 1:numel(outer(1).ApiFiles)
%     outer(1).ApiFiles(i).Content = jsondecode( outer(1).ApiFiles(i).Content );
% end

% % replace with your own kc3 file or equivalent method of sortie importing
% jsonText = fileread('KC3sortie_はあちゃま_20251130.json');
jsonText = fileread('KC3sortie_はあちゃま_20251216.json');
data = jsondecode(jsonText);


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

for i = 1:N
fld = sprintf('s%d', s_start+i);   % constructs 's15660', 's15661', ...
if isfield(data, fld)
dat = data.(fld);   % access data.sXXXXX.world
% ignore sorties where kc3 crashed (invalid data)
if (dat.world == 3 && dat.mapnum == 4) && dat.id ~= 17681 && dat.id ~=18117 && dat.id ~= 18223 && dat.id ~= 18569 && dat.id ~= 19646
    if length(dat.battles) == 2
        if dat.battles{1, 1}.data.api_formation(1) == 6 && dat.battles{2, 1}.data.api_formation(1) == 6 && dat.fleet1(1).mst_id == 623
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
    tally34(i).yuubaricond = tally34(i).data.fleet1(1).morale;
    tally34(i).mogamicond = tally34(i).data.fleet1(6).morale;
    if tally34(i).data.fleet1(4).mst_id == 961
        tally34(i).fleetnumber = 1;
    else
        tally34(i).fleetnumber = 2;
    end
    tally34(i).id = tally34(i).data.id;
    if tally34(i).reached == 1
        [tally34(i).bucket,tally34(i).repairfuel,tally34(i).repairsteel] = countbucket(tally34(i).data);
        tally34(i).fssunk = enemyfssunk(tally34(i).data);
        tally34(i).bossrank = ratings(tally34(i).data);
    else
        tally34(i).bucket = 1;
        tally34(i).repairfuel = 18.975;
        tally34(i).repairsteel = 35.775;
        tally34(i).fssunk = 0;
        tally34(i).bossrank = 0;
    end
end

v = [tally34.yuubaricond];
u = [tally34.fleetnumber];

f1_yuubari_to38 = sum(v <= 38 & u == 1)/length(tally34);
f1_yuubari_39to48 = sum(v >= 39 & v <=48& u == 1)/length(tally34);
f1_yuubari_49to = sum(v >= 49& u == 1)/length(tally34);
f2_yuubari_to38 = sum(v <= 38 & u == 2)/length(tally34);
f2_yuubari_39to48 = sum(v >= 39 & v <=48 & u == 2)/length(tally34);
f2_yuubari_49to = sum(v >= 49 & u == 2)/length(tally34);

v = [tally34.mogamicond];
f1_mogami_to52 = sum(v <= 52 & u == 1)/sum(u == 1);
f1_mogami_53to = sum(v >= 53 & u == 1)/sum(u == 1);
f2_mogami_to52 = sum(v <= 52 & u == 2)/sum(u == 2);
f2_mogami_53to = sum(v >= 53 & u == 2)/sum(u == 2);

reachrate = sum([tally34.reached])/length(tally34);

count = length(tally34);

