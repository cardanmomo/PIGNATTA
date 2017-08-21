
figure('Units','normalized','PaperPositionMode','auto');
c_new = get(equil_new, 'convergence');
c_j2 = get(equil_j2, 'convergence');
c_j3 = get(equil_j3, 'convergence');
c_j4 = get(equil_j4, 'convergence');
c_j5 = get(equil_j5, 'convergence');
c_j6 = get(equil_j6, 'convergence');
c_j7 = get(equil_j7, 'convergence');

l0 = get(c_new, 'store');
l2 = get(c_j2, 'store');
l3 = get(c_j3, 'store');
l4 = get(c_j4, 'store');
l5 = get(c_j5, 'store');
l6 = get(c_j6, 'store');
l7 = get(c_j7, 'store');


p1 = semilogy(l0, 'color', 'k');
hold on
p2 = semilogy(l2, 'color', 'r');
p3 = semilogy(l3, 'color', 'b');
p4 = semilogy(l4, 'color', 'g');
p5 = semilogy(l5, 'color', 'c');
p6 = semilogy(l6, 'color', 'm');
p7 = semilogy(l7, 'color', 'y');

set(gca, 'XLim', [0, length(l0)], 'YLim', [1e-7, 1])   
ylabel('Convergence parameter')
title('')
legend(num2str(li(equil_new)), num2str(li(equil_j2)), ...
    num2str(li(equil_j3)), num2str(li(equil_j4)), ...
    num2str(li(equil_j5)), num2str(li(equil_j6)), num2str(li(equil_j7)))