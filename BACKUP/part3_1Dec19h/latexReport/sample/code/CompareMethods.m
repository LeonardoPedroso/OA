% CompareMethods.m
%% Initialization
clear;
clc;
NDataSets = 4;

%% Load solution for both methods for all datasets
data = cell(2,NDataSets);
for i = 1:NDataSets
    data{1,i} = load(sprintf("./DATA/GradientDescent/GDsolDataset%d.mat",i),...
    'xGD','ItGD','normGradGD','elapsedTimeGD'); 
    data{2,i} = load(sprintf("./DATA/NewtonAlgorithm/NAsolDataset%d.mat",i),...
    'xNA','ItNA','normGradNA','elapsedTimeNA'); 
end

%% Compare iterations 
fprintf("-------------------------------------------------------------------\n");
fprintf("Method \t\t# Iterations \tTime elapsed\tAvg time/iteration \n");
for i = 1:NDataSets
    fprintf("GD (ds %d)\t%d \t\t%g s\t%g s \n",i,data{1,i}.ItGD,data{1,i}.elapsedTimeGD,data{1,i}.elapsedTimeGD/data{1,i}.ItGD);
    fprintf("NA (ds %d)\t%d \t\t%g s\t%g s\n",i,data{2,i}.ItNA,data{2,i}.elapsedTimeNA,data{2,i}.elapsedTimeNA/data{2,i}.ItNA);
end
fprintf("-------------------------------------------------------------------\n");

%% Plot result
plotResults = false;
if plotResults
for i = 1:NDataSets
if i<= 2
    load(sprintf("./data%d.mat",i),'X','Y'); % upload data set
    K = length(Y);
    figure('units','normalized','outerposition',[0 0 1 1]);
    set(gca,'FontSize',35);
    hold on;
    ax = gca;
    ax.XGrid = 'on';
    ax.YGrid = 'on';
    axis equal;
    for k = 1:K
        if Y(k)
            scatter(X(1,k),X(2,k),200,'o','b','LineWidth',3); 
        else
            scatter(X(1,k),X(2,k),200,'o','r','LineWidth',3); 
        end
    end
    %ylim([-4 8]);
    %xlim([-4 8]);
    title(sprintf("Dataset %d",i));
    ylabel('$x_2$','Interpreter','latex');
    xlabel('$x_1$','Interpreter','latex');
    x1 = (min(X(1,:)):(max(X(1,:)-min(X(1,:))))/100:max(X(1,:)));
    plot(x1,(data{1,i}.xGD(3)-data{1,i}.xGD(1)*x1)/data{1,i}.xGD(2),'-.g','LineWidth',4);
    plot(x1,(data{2,i}.xNA(3)-data{2,i}.xNA(1)*x1)/data{2,i}.xNA(2),'--m','LineWidth',4);
    saveas(gcf,sprintf("./DATA/Comparison/ComparisonSolDataset%d.fig",i));
    %close(gcf);
    hold off; 
end

figure('units','normalized','outerposition',[0 0 1 1]);
plot(1:data{1,i}.ItGD+1,data{1,i}.normGradGD,'LineWidth',3);
hold on;
plot(1:data{2,i}.ItNA+1,data{2,i}.normGradNA,'LineWidth',3);
set(gca,'FontSize',35);
ax = gca;
ax.XGrid = 'on';
ax.YGrid = 'on';
title(sprintf("Comparison GD vs NA | Dataset %d",i));
ylabel('$||\Delta f (s_k,r_k)||$','Interpreter','latex');
xlabel('$k$','Interpreter','latex');
set(gca, 'YScale', 'log');
legend('Gradient descent','Newton algorithm');
saveas(gcf,sprintf("./DATA/Comparison/ComparisonNormGradDataset%d.fig",i));
%close(gcf);
hold off;

end
end
    

