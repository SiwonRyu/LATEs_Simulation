% Print Figure X
% Describe distribution of m-compliance types for each design
clear all
close all

load("data\fig1.mat")
load("data\fig2.mat")
load("data\fig3.mat")
load("data\fig4.mat")

figure1 = figure;
subplot1 = subplot(2,2,1,'Parent',figure1);
hold(subplot1,'on');
    plot11 = plot(Xmat_des1(:,1),Ymat_des1(:,1),'Parent',subplot1,'LineWidth',2);           
    plot12 = plot(Xmat_des1(:,2),Ymat_des1(:,2),'Parent',subplot1,'LineWidth',2);
    set(plot11,'Color',[1 0 0],'DisplayName','Unit 1');
    set(plot11,'LineStyle','-');

    set(plot12,'Color',[0 0 1],'DisplayName','Unit 2');
    set(plot12,'LineStyle','--');
    
    ylabel({'$ P_i $'},'Interpreter','latex','Rotation',0, 'Position',[-0.17 0.33]);
    xlabel({'$T_i$'},'FontName','Serif','Interpreter','latex');
    title({'Design 1'},'FontName','Serif');
    box(subplot1,'on');
hold(subplot1,'off');

set(subplot1,'FontName','Serif','FontSize',15);
legend1 = legend(subplot1,'show');
set(legend1,'Position',[-0.31 0.37 1 1]);


subplot2 = subplot(2,2,2,'Parent',figure1);
hold(subplot2,'on');
    plot21 = plot(Xmat_des2(:,1),Ymat_des2(:,1),'Parent',subplot2,'LineWidth',2);           
    plot22 = plot(Xmat_des2(:,2),Ymat_des2(:,2),'Parent',subplot2,'LineWidth',2);
    set(plot21,'Color',[1 0 0],'DisplayName','Unit 1');
    set(plot21,'LineStyle','-');

    set(plot22,'Color',[0 0 1],'DisplayName','Unit 2');
    set(plot22,'LineStyle','--');
    
    ylabel({'$ P_i $'},'Interpreter','latex','Rotation',0, 'Position',[-0.17 0.33]);
    xlabel({'$T_i$'},'FontName','Serif','Interpreter','latex');
    title({'Design 2'},'FontName','Serif');
    box(subplot2,'on');
hold(subplot2,'off');

set(subplot2,'FontName','Serif','FontSize',15);
legend2 = legend(subplot2,'show');
set(legend2,'Position',[0.13 0.37 1 1]);


subplot3 = subplot(2,2,3,'Parent',figure1);
hold(subplot3,'on');
    plot31 = plot(Xmat_des3(:,1),Ymat_des3(:,1),'Parent',subplot3,'LineWidth',2);           
    plot32 = plot(Xmat_des3(:,2),Ymat_des3(:,2),'Parent',subplot3,'LineWidth',2);
    set(plot31,'Color',[1 0 0],'DisplayName','Unit 1');
    set(plot31,'LineStyle','-');

    set(plot32,'Color',[0 0 1],'DisplayName','Unit 2');
    set(plot32,'LineStyle','--');
    
    ylabel({'$ P_i $'},'Interpreter','latex','Rotation',0, 'Position',[-0.17 0.33]);
    xlabel({'$T_i$'},'FontName','Serif','Interpreter','latex');
    title({'Design 3'},'FontName','Serif');
    box(subplot3,'on');
hold(subplot3,'off');

set(subplot3,'FontName','Serif','FontSize',15);
legend3 = legend(subplot3,'show');
set(legend3,'Position',[-0.31 -0.1 1 1]);


subplot4 = subplot(2,2,4,'Parent',figure1);
hold(subplot4,'on');
    plot41 = plot(Xmat_des4(:,1),Ymat_des4(:,1),'Parent',subplot4,'LineWidth',2);           
    plot42 = plot(Xmat_des4(:,2),Ymat_des4(:,2),'Parent',subplot4,'LineWidth',2);
    set(plot41,'Color',[1 0 0],'DisplayName','Unit 1');
    set(plot41,'LineStyle','-');

    set(plot42,'Color',[0 0 1],'DisplayName','Unit 2');
    set(plot42,'LineStyle','--');
    
    ylabel({'$ P_i $'},'Interpreter','latex','Rotation',0, 'Position',[-0.17 0.33]);
    xlabel({'$T_i$'},'FontName','Serif','Interpreter','latex');
    title({'Design 4'},'FontName','Serif');
    box(subplot4,'on');
hold(subplot4,'off');

set(subplot4,'FontName','Serif','FontSize',15);
legend4 = legend(subplot4,'show');
set(legend4,'Position',[0.13 -0.1 1 1]);

figure1.Position = [747, 339, 1000, 700]

print(figure1,'Figure_types.svg','-dsvg');