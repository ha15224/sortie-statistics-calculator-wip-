cumbucket = 0;
cumbuckaverage = zeros(count,1);
for i = 1:count
    cumbucket = cumbucket + tally34(i).bucket;
    cumbuckaverage(i) = cumbucket/i;
end
semilogx(cumbuckaverage)
ylim([0,max(cumbuckaverage)+0.5])
grid on
xlabel('trials')
ylabel('observed average bucket')



% cumfssunk = 0;
% cumfssunkaverage = zeros(count,1);
% for i = 1:count
%     cumfssunk = cumfssunk + tally34(i).fssunk;
%     cumfssunkaverage(i) = cumfssunk/i;
% end
% 
% semilogx(cumfssunkaverage)
% ylim([0,max(cumfssunkaverage)+0.5])
% grid on
% xlabel('trials')
% ylabel('observed fs sinking rate')



% ratings = zeros(count+1,4);
% rankrate = zeros(count,4);
% reachcount = 0;
% for i = 1:count
%     rank_temp = zeros(1,4);
%     if tally34(i).bossrank ~= 0 
%         reachcount = reachcount + 1;
%         rank_temp(tally34(i).bossrank) = 1;
%     end
%     ratings(i+1,:) = ratings(i,:) + rank_temp;
%     rankrate(i,:) = ratings(i+1,:)/reachcount;
% end
% plot(rankrate)
% % semilogx(rankrate)
% xlabel('trials')
% ylabel('cumulative boss rank')
% legend('C-rank','B-rank','A-rank','S-rank')
% grid on
