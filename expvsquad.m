% exponential vs quadratic

% load census
% % The workspace contains two new variables:
% % cdate is a column vector containing the years 1790 to 1990 in 10-year increments.
% % pop is a column vector with the U.S. population figures that correspond to the years in cdate .
% 
% plot(cdate,pop,'o')
% % fit quadratic 
% [population2,gof] = fit(cdate,pop,'poly2');
% 
% plot(population2,cdate,pop);
% % Move the legend to the top left corner.
% legend('Location','NorthWest');
% populationExp = fit(cdate,pop,'exp1');
% hold on
% plot(populationExp,'r--');
% 
% figure(2)
% subplot(121)
% plot(population2,cdate,pop,'residuals');
% subplot(122)
% plot(populationExp,cdate,pop,'residuals');

%% for flow-speed data

% [quad,gofq] = fit(logselFN(:),selspeed(:),'poly2');

figure(1), clf
plot(c,logselFN,selspeed);
% Move the legend to the top left corner.
[Exp,gofE] = fit(logselFN(:),selspeed(:),'exp1');
hold on
plot(Exp,'r--');

figure(2), clf
subplot(121)
plot(c,logselFN(:),selspeed(:),'residuals');
subplot(122)
plot(Exp,logselFN(:),selspeed(:),'residuals');

figure (98), hold on 
plot(ID,gofE.rmse,'rx', ID,gofE.rsquare,'ro')
plot(ID,g.rmse,'bx', ID,g.rsquare,'bo')

xlabel('Tag Number'), ylabel('Value'), legend('Exp RMSE','Exp R^2','Quad RMSE','Quad R^2')
adjustfigurefont('Helvetica',14)
set(gca,'xlim',[0 11],'xtick',1:10)
print('NARW_FlowSoundFitCompare','-dpng','-r300')