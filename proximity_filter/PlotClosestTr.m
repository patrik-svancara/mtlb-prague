function [] = PlotClosestTr(tr,trind)
%PlotClosestTr Plots given trajectory with the closest one

clf;

plot(tr(trind).pos(:,1),tr(trind).pos(:,2),'.-','LineWidth',1.5);
hold on;

[~,minind] = min(tr(trind).dst);
plot(tr(minind).pos(:,1),tr(minind).pos(:,2),'.-','LineWidth',1.5);

hold off;

end
