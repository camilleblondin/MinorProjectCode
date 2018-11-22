function  plotError(errortest,stdtest,errortrain,stdtrain,atitle,modelName)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

x = 1:length(errortest);

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
% Set the remaining axes properties
set(axes1,'FontName','Helvetica Neue','FontSize',18,'XTick',[1:length(modelName)],...
    'XTickLabel',...
    modelName);
% Create legend
legend(axes1,'show');

hold on
bar(x,errortest)
errorbar(errortest,stdtest ,'.');
hold on;
bar(x,errortrain )
hold on;
errorbar(errortrain ,stdtrain,'.');

ylim([0 0.5])
legend('test','std test','training','std training');
title(atitle);
grid on;

end

