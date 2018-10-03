function axletter(gca,label)
% get axis position and x and y position for text for letter
% default is 0.05x and 0.95y, fontsize 18, weight bold 
yl = get(gca,'ylim');
xl = get(gca,'xlim'); 
    text(xl(1)+diff(xl)*0.05,yl(1)+diff(yl)*0.95,label,'FontSize',18,'FontWeight','Bold')
end

    