function axletter(gca,label,FS,xloc,yloc)
% get axis position and x and y position for text for letter
% default is 0.05x and 0.95y, fontsize 18, weight bold 
if nargin < 3
    FS = 18; 
end
if nargin < 4 
    xloc = 0.05;
end
if nargin < 5
    yloc = 0.95;
end


yl = get(gca,'ylim');
xl = get(gca,'xlim'); 
    text(xl(1)+diff(xl)*xloc,yl(1)+diff(yl)*yloc,label,'FontSize',FS,'FontWeight','Bold')
end

    