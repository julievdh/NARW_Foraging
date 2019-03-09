MSA = msa(Aw);
figure(31), clf
ax(1) = subplot(411);
plot(t/60,MSA), ylabel('MSA (g)'), grid on
ax(2) = subplot(412);
plot(t/60,ph), ylabel('Pitch Deviation (deg)'), grid on
ylim([-0.25 0.25])
ax(3) = subplot(413);
plot(t/60,Aw), ylabel('Acceleration (g)'), grid on
ax(4) = subplot(414);
plot(t/60,-p), ylabel('Depth (m)'), grid on
linkaxes(ax,'x')
xlim([606 664]), xlabel('Time (min)')

adjustfigurefont
print('NARW-PRH-depth.png','-dpng','-r90')
