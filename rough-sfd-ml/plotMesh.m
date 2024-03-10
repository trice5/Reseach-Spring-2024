function  plotMesh(TRIANGLES,NODES) 
% Plots the mesh


trisurf(TRIANGLES,NODES(:,1),NODES(:,2),NODES(:,3),'LineWidth',.5)
hold on
numNodes = length(NODES);

set(gca,'TickLabelInterpreter','Latex')
set(gca,'TickLabelInterpreter','Latex')
colormap default
xlabel('$\tilde{x}_1$','Interpreter','Latex')
ylabel('$\tilde{x}_2$','Interpreter','Latex')
zlabel('$\tilde{x}_3$','Interpreter','Latex')
set(gca,'XMinorTick','on')
set(gca,'YMinorTick','on')
set(gca,'ZMinorTick','on')
set(gca,'FontSize',12)
set(gca,'LineWidth',1)
box on
grid off
axis equal
end

