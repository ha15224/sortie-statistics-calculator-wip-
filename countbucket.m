function [output,hps] = countbucket(data)

output = 0;

maxhps = data.battles{2, 1}.data.api_f_maxhps;

if isempty(fieldnames(data.battles{2, 1}.yasen))
    % ends day battle
    hps = data.battles{2, 1}.data.api_f_nowhps;
   
    % airstrike
    hps = hps - floor(data.battles{2, 1}.data.api_kouku.api_stage3.api_fdam);

    % otorps exist but only care about allied damage

    % first shelling
    for i=1:length(data.battles{2, 1}.data.api_hougeki1.api_at_eflag)
        if data.battles{2, 1}.data.api_hougeki1.api_at_eflag(i) == 1
            if iscell(data.battles{2,1}.data.api_hougeki1.api_df_list)
                idx = data.battles{2,1}.data.api_hougeki1.api_df_list{i}(1) + 1;
            else
                idx = data.battles{2,1}.data.api_hougeki1.api_df_list(i) + 1;
            end

            if iscell(data.battles{2, 1}.data.api_hougeki1.api_damage)
                damage = sum(floor(data.battles{2, 1}.data.api_hougeki1.api_damage{i}));
            else
                damage = sum(floor(data.battles{2, 1}.data.api_hougeki1.api_damage(i)));
            end
            hps(idx) = hps(idx) - damage;
        end
    end

    % second shelling
    if data.battles{2, 1}.data.api_hourai_flag(2) == 1
        for i=1:length(data.battles{2, 1}.data.api_hougeki2.api_at_eflag)
        if data.battles{2, 1}.data.api_hougeki2.api_at_eflag(i) == 1
            if iscell(data.battles{2,1}.data.api_hougeki2.api_df_list)
                idx = data.battles{2,1}.data.api_hougeki2.api_df_list{i}(1) + 1;
            else
                idx = data.battles{2,1}.data.api_hougeki2.api_df_list(i) + 1;
            end
            if iscell(data.battles{2, 1}.data.api_hougeki2.api_damage)
                damage = sum(floor(data.battles{2, 1}.data.api_hougeki2.api_damage{i}));
            else
                damage = sum(floor(data.battles{2, 1}.data.api_hougeki2.api_damage(i)));
            end
            hps(idx) = hps(idx) - damage;
        end
        end
    end
        
    % ctorps
    if data.battles{2, 1}.data.api_hourai_flag(4) == 1
        hps = hps - floor(data.battles{2, 1}.data.api_raigeki.api_fdam(1:6));
    end
else
    % ends night battle
    hps = data.battles{2, 1}.yasen.api_f_nowhps;
    
    for i=1:length(data.battles{2, 1}.yasen.api_hougeki.api_at_eflag)
    if data.battles{2, 1}.yasen.api_hougeki.api_at_eflag(i)==1
        if iscell(data.battles{2, 1}.yasen.api_hougeki.api_df_list)
            idx = data.battles{2, 1}.yasen.api_hougeki.api_df_list{i}(1) + 1;
        else
            idx = data.battles{2, 1}.yasen.api_hougeki.api_df_list(i) + 1;
        end
            damage = sum(floor(data.battles{2, 1}.yasen.api_hougeki.api_damage{i}));
            hps(idx) = hps(idx) - damage;
    end
    end
end

if hps(1) <= maxhps(1)/2
    output = output + 1;
end
if hps(2) <= maxhps(2)/2
    output = output + 1;
end
if hps(3) <= maxhps(3)/4 % only bucket hatsu on chuuha
    output = output + 1;
end
if hps(4) <= maxhps(4)/2
    output = output + 1;
end
if hps(5) <= maxhps(5)/2
    output = output + 1;
end
if hps(6) <= maxhps(6)/2
    output = output + 1;
end

hps = hps./maxhps;


end