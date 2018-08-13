figure(19), clf, hold on
plot(t*3600,-p)


for i = 1:size(T,1)
    if isempty(dive(i).stops) ~= 1
        h = errorbar(T(i,1),mean(dive(i).stops(:,2)-dive(i).stops(:,1)),std(dive(i).stops(:,2)-dive(i).stops(:,1)),'ko','markerfacecolor','k');
        %h.CapSize = 12;
        plot(dive(i).stops(:,1),dive(i).stops(:,2)-dive(i).stops(:,1),'.-','color',[0.7 0.7 0.7])
        % plot volume
        h = errorbar(T(i,1),mean(dive(i).vperblock),std(dive(i).vperblock),'ro','markerfacecolor','r');
        plot(dive(i).stops(:,1),dive(i).vperblock,'.-','color',[1 0.7 0.7])
       
        %plot([T(i,1) T(i,2)],[mean(stops(:,2)-stops(:,1)) mean(stops(:,2)-stops(:,1))])
    end
end
title(regexprep(tag,'_',' '))
xlabel('Time (seconds)')
ylabel('Depth (m)') 
adjustfigurefont

