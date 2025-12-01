function [output] = enemyfssunk(data)



if isempty(fieldnames(data.battles{2, 1}.yasen))
    % ends day battle

    % enemy flagship health
    efs = data.battles{2, 1}.data.api_e_nowhps(1);
   
    % airstrike
    efs = efs - data.battles{2, 1}.data.api_kouku.api_stage3.api_edam(1);

    % otorp
    efs = efs - data.battles{2, 1}.data.api_opening_atack.api_edam(1);

    % first shelling
    for i=1:length(data.battles{2, 1}.data.api_hougeki1.api_at_eflag)
        if data.battles{2, 1}.data.api_hougeki1.api_at_eflag(i) == 0
            if iscell(data.battles{2,1}.data.api_hougeki1.api_df_list)
                idx = data.battles{2,1}.data.api_hougeki1.api_df_list{i};
            else
                idx = data.battles{2,1}.data.api_hougeki1.api_df_list(i);
            end
            if idx == 0
            if iscell(data.battles{2, 1}.data.api_hougeki1.api_damage)
                damage = sum(floor(data.battles{2, 1}.data.api_hougeki1.api_damage{i}));
            else
                damage = sum(floor(data.battles{2, 1}.data.api_hougeki1.api_damage(i)));
            end
            efs = efs - damage;
            end
        end
    end

    % second shelling
    if data.battles{2, 1}.data.api_hourai_flag(2) == 1
        for i=1:length(data.battles{2, 1}.data.api_hougeki2.api_at_eflag)
        if data.battles{2, 1}.data.api_hougeki2.api_at_eflag(i) == 0
            if iscell(data.battles{2,1}.data.api_hougeki2.api_df_list)
                idx = data.battles{2,1}.data.api_hougeki2.api_df_list{i};
            else
                idx = data.battles{2,1}.data.api_hougeki2.api_df_list(i);
            end
            if idx == 0
            if iscell(data.battles{2, 1}.data.api_hougeki2.api_damage)
                damage = sum(floor(data.battles{2, 1}.data.api_hougeki2.api_damage{i}));
            else
                damage = sum(floor(data.battles{2, 1}.data.api_hougeki2.api_damage(i)));
            end
            efs = efs - damage;
            end
        end
        end
    end
        
    % ctorps
    if data.battles{2, 1}.data.api_hourai_flag(4) == 1
        efs = efs - floor(data.battles{2, 1}.data.api_raigeki.api_edam(1));
    end
else
    % ends night battle
    efs = data.battles{2, 1}.yasen.api_e_nowhps(1);
    
    for i=1:length(data.battles{2, 1}.yasen.api_hougeki.api_at_eflag)
    if data.battles{2, 1}.yasen.api_hougeki.api_at_eflag(i)==0
        if iscell(data.battles{2, 1}.yasen.api_hougeki.api_df_list)
            idx = data.battles{2, 1}.yasen.api_hougeki.api_df_list{i}(1);
        else
            idx = data.battles{2, 1}.yasen.api_hougeki.api_df_list(i);
        end
        if idx == 0
            damage = sum(floor(data.battles{2, 1}.yasen.api_hougeki.api_damage{i}));
            efs = efs - damage;
        end
    end
    end
end

if efs <= 0
    output = 1;
else
    output = 0;
end


end