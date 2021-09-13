% Create a STEM plot of the following discrete time signal:
sigTitle = 'Sample';

close all
format compact

% Set k limits
K1 = 0;
K2 = 50;
k = [K1:1:K2];

% Signal definition
x = 2*k;

% Plot and formatting
figure
stem(k,x,'k','filled','LineWidth',2)
xlabel('{\itk}  (Samples)','FontName','Times New Roman','FontSize',12)
ylim([(0.9*min(x)-0.1*max(x)) (1.1*max(x)-0.1*min(x))])
xlim([(0.9*K1-0.1*K2) (1.1*K2-0.1*K1)])
ylabel('{\itx}[{\itk}] ','FontName','Times New Roman','FontSize',12)
title(sigTitle,'FontName','Times New Roman','FontSize',14)
grid on
