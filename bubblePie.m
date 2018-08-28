function bubblePie(points,prob,r,clr)

numPoints = size(points,1);
numClasses = size(prob,2);

%# pie parameters
theta = linspace(0, 2*pi, 100); %# steps to approximate a circle

%# pie circles
px = bsxfun(@plus, cos(theta).*r, points(:,1))';
py = bsxfun(@plus, sin(theta).*r, points(:,2))';
px(end+1,:) = NaN; py(end+1,:) = NaN;

%# pie divisions
tt = cumsum(prob,2) .* 2*pi;
qx = cat(3, ...
    bsxfun(@plus, cos(tt).*r, points(:,1)), ...
    repmat(points(:,1), [1 numClasses]), ...
    NaN(numPoints,numClasses));
qy = cat(3, ...
    bsxfun(@plus, sin(tt).*r, points(:,2)), ...
    repmat(points(:,2), [1 numClasses]), ...
    NaN(numPoints,numClasses));
qx = permute(qx, [3 2 1]); qy = permute(qy, [3 2 1]);

%# plot
% figure
% line(px(:), py(:), 'Color','k')
% line(qx(:), qy(:), 'Color','k')
% axis equal

% clr = hsv(numClasses+1);          %# colors for each class
clr = [0,0,0;clr;1,1,1];
tt = cumsum(prob,2) .* 2*pi;    %# pie divisions

%figure
h = zeros(numPoints,numClasses);    %# handles to patches
for idx=1:numPoints                 %# for each point
    for k=1:numClasses              %# for each class
        %# start/end angle of arc
        if k>1
            t(1) = tt(idx,k-1);
        else
            t(1) = 0;
        end
        t(2) = tt(idx,k);

        %# steps to approximate an arc from t1 to t2
        theta = linspace(t(1), t(2), 50);

        %# slice (line from t2 to center, then to t1, then an arc back to t2)
        x = points(idx,1) + r .* [cos(t(2)) ; 0 ; cos(t(1)) ; cos(theta(:))];
        y = points(idx,2) + r .* [sin(t(2)) ; 0 ; sin(t(1)) ; sin(theta(:))];
        h(idx,k) = patch('XData',x, 'YData',y, ...
            'FaceColor',clr(k+1,:), 'EdgeColor','k');

        %# show percentage labels
%         ind = fix(numel(theta)./2) + 3;     %# middle of the arc
%         text(x(ind), y(ind), sprintf('%.2f%%', prob(idx,k)*100), ...
%             'Color','k', 'FontSize',6, ...
%             'VerticalAlign','middle', 'HorizontalAlign','left');
    end
end
axis equal