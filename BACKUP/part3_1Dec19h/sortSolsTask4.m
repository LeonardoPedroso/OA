%% Set parameters
NRuns = 1;
NIts = 12*2;

k = 2;

%% Sort solutions found
solSorted = zeros(NRuns*NIts,3);
count = 0;
for i = 1:NRuns
   data = load(sprintf("./data/RunsTask4/solRUN%02d.mat",i));
   for j = 1:NIts
       count = count+1;
       solSorted(count,1) = i;
       solSorted(count,2) = j; 
       solSorted(count,3) = data.costLM{j,1}(end,1);
   end
end
solSorted = sortrows(solSorted,3);
save("./data/solSortedTask4.mat",'solSorted');

%% Best solution
data = load(sprintf("./data/RunsTask4/solRUN%02d.mat",solSorted(1,1)));
solLM = data.solLM{solSorted(1,2),1};
itLM = data.itLM(solSorted(1,2),1);
elapsedTimeLM = data.elapsedTimeLM(solSorted(1,2),1);
costLM = data.costLM{solSorted(1,2),1};
normGradLM = data.normGradLM{solSorted(1,2),1};

save("./data/solBestTask4.mat",...
     'solLM','itLM','elapsedTimeLM','costLM','normGradLM');

%% Plot best solution

figure('units','normalized','outerposition',[0 0 1 1]);
yyaxis left
plot(0:itLM(k-1,1),costLM,'LineWidth',3);
hold on;
ylabel('$f(y)$','Interpreter','latex');
set(gca, 'YScale', 'log');
yyaxis right
plot(0:itLM(k-1,1),normGradLM,'LineWidth',3);
ylabel('$||\nabla f (y)||$','Interpreter','latex');
set(gca,'FontSize',35);
ax = gca;
ax.XGrid = 'on';
ax.YGrid = 'on'; 
title(sprintf("LM algorithm | Dataset task 4 | k = %d",k));
set(gca, 'YScale', 'log');
xlabel('$k$','Interpreter','latex');
saveas(gcf,"./data/task4_LM.fig");
%close(gcf);
hold off;
y = reshape(solLM,[k,N]);
figure('units','normalized','outerposition',[0 0 1 1]);
scatter(y(1,:),y(2,:),100,'o','b','LineWidth',1,'MarkerFaceColor','flat');
hold on;
set(gca,'FontSize',35);
ax = gca;
ax.XGrid = 'on';
ax.YGrid = 'on'; 
title(sprintf("LM algorithm | Dataset task 4 | k = %d",k));
saveas(gcf,sprintf("./data/task4_sol.fig"));
%close(gcf);
hold off;


