function drawCircleLine(wedge,r,color,lbl,outFileName)
% draw circle line plot
% wedge: M*N matrix containing fraction of samples of each N charateristic, for total of M clones
% r: M*N matrix containing the size of circle of each N charateristic, for total of M clones
% color: N*3 matrix containing rbg data of each N characteristic
% lbl: N*1 cell containing label of each N charateristic
% outFileName: name of the output file
% bubblePie credits to Amro https://stackoverflow.com/questions/11073889/scatter-pie-plot

% begin drawing
figure('position',[0 0 1600 800]);
% page count
m = 1;
% total on page count
n = 0;
% total count
l = 0;
% row number
rn = 40;
% column number
cn = 5;
% font size
fs = 6;
% header margin
hm = 2.5;
for i = 1:size(r,1)
    for j = 1:size(r,2)
        X = floor(n/rn)*(length(lbl)+1) + j;
        Y = rn - mod(n,rn)+1;
        bubblePie([X,Y],[wedge(i,j),1-wedge(i,j)],r(i,j),clr(j,:));
        hold on;
        % draw connecting line
        if j~=size(r,2)
            plot([X+r(i,j),X+1-r(i,j+1)],[Y,Y],'k');
            hold on;
        end
    end
    if mod(n,rn)==0
        for j = 1:size(lbl,1)
            X = floor(n/rn)*(length(lbl)+1) + j;
            Y = rn + hm;
            text(X,Y,char(lbl{j}),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',fs,'FontWeight','bold','Rotation',90);
        end
    end
    n = n + 1;
    l = l + 1;
    if n == rn*cn || l >= size(r,1)
        % draw legend
        X = cn*(length(lbl)+1)+3;
        bubblePie([X,rn],1,0.5,[1,1,1]);
        text(X+0.6,rn+0.1,'>1000','HorizontalAlignment','left','VerticalAlignment','middle','FontSize',fs,'FontWeight','bold');
        bubblePie([X,rn-1],1,0.4,[1,1,1]);
        text(X+0.6,rn-1+0.1,'101-1000','HorizontalAlignment','left','VerticalAlignment','middle','FontSize',fs,'FontWeight','bold');
        bubblePie([X,rn-2],1,0.3,[1,1,1]);
        text(X+0.6,rn-2+0.1,'11-100','HorizontalAlignment','left','VerticalAlignment','middle','FontSize',fs,'FontWeight','bold');
        bubblePie([X,rn-3],1,0.2,[1,1,1]);
        text(X+0.6,rn-3+0.1,'2-10','HorizontalAlignment','left','VerticalAlignment','middle','FontSize',fs,'FontWeight','bold');
        bubblePie([X,rn-4],1,0.05,[0,0,0]);
        text(X+0.6,rn-4+0.1,'1','HorizontalAlignment','left','VerticalAlignment','middle','FontSize',fs,'FontWeight','bold');
        hold off;
        axis off;
        set(gcf,'position',[0 0 1600 800]);
        outFileName = [outFileName,'_',num2str(m)];
        saveas(gcf,outFileName,'pdf');
        close('all');
        if l < size(r,1)
            figure('position',[0 0 1600 800]);
            m = m + 1;
            n = n - rn*cn;
        end
    end    
end
