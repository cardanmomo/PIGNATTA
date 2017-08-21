% Plotter for halves of equilibria for the project report.
title('')  % Remove title

% Make it beautiful
% Cut it half 
ylim([-2.1, 0])  
set(gca, 'Units', 'normalized', 'YTick', -2:0.5:0, 'XTick', 0:0.5:2, 'Position', [0.15, 0.4, 0.7, 0.8], 'FontUnits', 'points', 'FontWeight', 'normal', 'FontSize', 9)
% When complete:
%set(gca, 'Units', 'normalized', 'YTick', -2:0.5:2, 'XTick', 0:0.5:2, 'Position', [0.15, 0.24, 0.7, 0.75], 'FontUnits', 'points', 'FontWeight', 'normal', 'FontSize', 9, 'Layer', 'top')

% Make nice axis
ylabel('Z (m)', 'FontName', 'helvetica')
xlabel('R (m)', 'Fontname', 'helvetica')
box on
print -depsc2 /home/cmoreno/work/SD_linear_li.eps  % Save it
% If things go wrong, use:  
% figure('Units','normalized','PaperPositionMode','auto')