function output = ratings(data)

rank = data.battles{2, 1}.rating;

if any(strcmp(rank, {'SS','S'}))
    output = 4;
elseif strcmp(rank,'A')
    output = 3;
elseif strcmp(rank,'B')
    output = 2;
elseif strcmp(rank,'C')
    output = 1;
else
    error("unknown rank detected")
end



end