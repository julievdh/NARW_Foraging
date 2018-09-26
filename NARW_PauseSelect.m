reenter = 1; ct = 0;
while reenter == 1
    % input start of range
    disp('select start')
    figure(9), temp1 = ginput(1); % click on screen
    % find nearest glide selected by algorithm
    glall = vertcat(gl(:,1),gl(:,2)); % all glide indices
    glind1 = nearest(glall/60,temp1(1));
    plot(glall(glind1,1)/60,0,'go')
    % input end of range
    disp('select end')
    temp2 = ginput(1);
    glind2 = nearest(glall/60,temp2(1));
    plot(glall(glind2,1)/60,0,'ro')
    % store
    ct = ct+1;
    stops(ct,:) = [glall(glind1) glall(glind2)];
    % want to enter another?
    reenter = input('select another: 1 or 0? or 2 for final, 3 for other ');
    % end
end
while reenter == 2
    disp('select start')
    figure(9), temp1 = ginput(1); % click on screen
    % find nearest glide selected by algorithm
    glind1 = nearest(gl(:,1)/60,temp1(1));
    plot(gl(glind1,1)/60,0,'go')
    % input end of range
    disp('select end')
    temp2 = ginput(1);
    plot(temp2(1),0,'r*')
    ct = ct+1;
    stops(ct,:) = [gl(glind1,1) temp2(1)*60];
    reenter = input('select another: 1 or 0? 2 for final, 3 for other ');
end
while reenter == 3
    disp('select start')
    figure(9), temp1 = ginput(1); % click on screen
    % find nearest glide selected by algorithm
    plot(temp1(1),0,'g*')
    disp('select end')
    temp2 = ginput(1);
    plot(temp2(1),0,'r*')
    ct = ct+1;
    stops(ct,:) = [temp1(1)*60 temp2(1)*60];
    reenter = input('select another: 1 or 0? 2 for final, 3 for other ');
end
