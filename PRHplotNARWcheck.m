% see also FunEcol_RevisionCalcs for the next iteration of this 

load('NARW_foraging_tags')
ID = 8;
tag = tags{ID};
loadprh(tag);
t = (1:length(p))/fs;

MSA = msa(Aw);
[v,ph,mx,fr] = findflukes(Aw,Mw,fs,0.3,0.02,[2 8]); % calculate pitch deviation

figure(31), clf
ax(1) = subplot(411);
plot(t/60,MSA), ylabel('MSA (g)'), grid on
ax(2) = subplot(412);
plot(t/60,ph), ylabel('Pitch Deviation (deg)'), grid on
ylim([-0.25 0.25])
ax(3) = subplot(413);
plot(t/60,rad2deg([pitch roll head])), ylabel('Orientation (deg)'), grid on
ax(4) = subplot(414);
plot(t/60,-p), ylabel('Depth (m)'), grid on
linkaxes(ax,'x')
xlim([606 648]), xlabel('Time (min)')

adjustfigurefont('Helvetica',12)
print('NARW-PRH-depth.png','-dpng','-r90')
