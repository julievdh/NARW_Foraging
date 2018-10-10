whhead=[]; s = 1; 
figure(1), plot(ptrack(:,2),ptrack(:,1),'.-')
for n=0:length(ptrack)/5                      
    a=(s+n)*5; % select points - these appear to be 5 samples apart = 1 s                               
    a2=a+5;                                            
    p1=ptrack(a,:); p2=ptrack(a2,:);
    figure(1), hold on 
    plot(p2(2),p2(1),'om')
    plot(p1(2),p1(1),'ok')
    heady=p2(1)-p1(1); headx=p2(2)-p1(2);
    deghead=abs(atand(heady/headx));

    if headx<0 & heady>0
        deghead=270+deghead-360;
    elseif headx<0 & heady<0
        deghead=270-deghead-360;
    elseif headx>0 & heady<0
        deghead=deghead+90;
    elseif headx>0 & heady>0
        deghead=90-deghead;
    end

    xcd=30*cosd(90-deghead);
    ycd=30*sind(90-deghead);

    whhead=[whhead; n deghead xcd ycd a];

    figure(2), hold on 
    plot(n,deghead,'o')

    
end

whh=whhead(1:30:end,2);
xcd=whhead(1:30:end,3);
ycd=whhead(1:30:end,4);
% 
% [SUCCESS]=xlswrite('tag_whaleheadingsforDaveJ.xls',whhead(:,2),'226A_full','G2')
% 
% [SUCCESS]=xlswrite('tag_whaleheadings.xls',whh,'226A','J14')
% [SUCCESS]=xlswrite('tag_whaleheadings.xls',xcd,'226A','K14')
% [SUCCESS]=xlswrite('tag_whaleheadings.xls',ycd,'226A','M14')
% 
% 
% disp(whhead(1:30:end,:))

