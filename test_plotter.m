figure();
plot(equil_new, 'psi_boundary', 'k')
plot(equil_j2, 'psi_boundary', 'r')
plot(equil_j3, 'psi_boundary', 'b')
plot(equil_j4, 'psi_boundary', 'g')
plot(equil_j5, 'psi_boundary', 'c')
plot(equil_j6, 'psi_boundary', 'm')
plot(equil_j7, 'psi_boundary', 'y')
legend('new', 'j2', 'j3', 'j4', 'j5', 'j6', 'j7', 'location', 'se')

figure();
j = get(equil_new, 'j');
j2 = get(equil_j2, 'j');
j3 = get(equil_j3, 'j');
j4 = get(equil_j4, 'j');
j5 = get(equil_j5, 'j');
j6 = get(equil_j6, 'j');
j7 = get(equil_j7, 'j');
section(j3);
hold on
[r, v] = section(j);
[r, vj2] = section(j2);
[r, vj4] = section(j4);
[r, vj5] = section(j5);
[r, vj6] = section(j6);
[r, vj7] = section(j7);
plot(r,v, 'k')
plot(r, vj2, 'r')
plot(r, vj4, 'g')
plot(r, vj5, 'c')
plot(r, vj6, 'm')
plot(r, vj7, 'y')
legend('j3', 'new', 'j2', 'j4', 'j5', 'j6', 'j7', 'location', 'se')
xlabel('r (m)')
ylabel('J (A)')


figure();
plot(psi_j, j_prof, 'k')
hold on
plot(psi_j, j_prof2, 'r')
plot(psi_j, j_prof3, 'b')
plot(psi_j, j_prof4, 'g')
plot(psi_j, j_prof5, 'c')
plot(psi_j, j_prof6, 'm')
plot(psi_j, j_prof7, 'y')
legend('new', 'j2', 'j3', 'j4', 'j5', 'j6', 'j7')
xlabel('$\Psi_{n}$', 'interpreter', 'latex', 'fontsize', 19)
ylabel('J (A)')

figure();
plot([li(equil_new), li(equil_j2), li(equil_j3), li(equil_j4), li(equil_j5), li(equil_j6), li(equil_j7)])
hold on
plot([betap(equil_new), betap(equil_j2), betap(equil_j3), betap(equil_j4), betap(equil_j5), betap(equil_j6), betap(equil_j7)], 'r')
legend('internal inductance', 'poloidal beta')
xlabel('Profile number')
ylabel('Magnitude')

figure();
plot([uno_a(1), dos_a(1), tres_a(1), cuatro_a(1), cinco_a(1), seis_a(1), siete_a(1)], 'ro')
hold on
plot([uno_a(2), dos_a(2), tres_a(2), cuatro_a(2), cinco_a(2), seis_a(2), siete_a(2)], 'bx')
plot([uno_a(2), dos_a(3), tres_a(3), cuatro_a(3), cinco_a(3)], 'g.')
legend('1st', '2nd', '3rd', 'location', 'se')
plot([uno_a(1), dos_a(1), tres_a(1), cuatro_a(1), cinco_a(1), seis_a(1), siete_a(1)], 'r')
plot([uno_a(2), dos_a(2), tres_a(2), cuatro_a(2), cinco_a(2), seis_a(2), siete_a(2)], 'b')
plot([uno_a(2), dos_a(3), tres_a(3), cuatro_a(3), cinco_a(3)], 'g')
title('Alpha coefficient')
xlabel('Profile number')
ylabel('Magnitude')

figure();
plot([uno_b(1), dos_b(1), tres_b(1), cuatro_b(1), cinco_b(1), seis_b(1), siete_b(1)], 'ro')
hold on
plot([uno_b(2), dos_b(2), tres_b(2), cuatro_b(2), cinco_b(2), seis_b(2), siete_b(2)], 'bx')
plot([uno_b(2), dos_b(3), tres_b(3), cuatro_b(3), cinco_b(3)], 'g.')
legend('1st', '2nd', '3rd', 'location', 'se')
plot([uno_b(1), dos_b(1), tres_b(1), cuatro_b(1), cinco_b(1), seis_b(1), siete_b(1)], 'r')
plot([uno_b(2), dos_b(2), tres_b(2), cuatro_b(2), cinco_b(2), seis_b(2), siete_b(2)], 'b')
plot([uno_b(2), dos_b(3), tres_b(3), cuatro_b(3), cinco_b(3)], 'g')
title('Beta coefficient')
xlabel('Profile number')
ylabel('Magnitude')


[x_new, y_new, conn_new] = control_pointsV3(equil_new);

for i=2:7
    eval(['[' sprintf('x_j%d,', i) sprintf('y_j%d,', i) sprintf('cl_j%d', i) ']' '=' sprintf('control_pointsV3(equil_j%d);', i)]);
    eval([sprintf('d_%d = (', i) sprintf('(x_j%d-x_new).^2+', i) sprintf('(y_j%d-y_new).^2).^(0.5);', i)]);
    imp(i-1) = eval(sprintf('d_%d(1);', i));
    omp(i-1) = eval(sprintf('d_%d(2);', i));
    xpoint(i-1) = eval(sprintf('d_%d(3);', i));
    isp(i-1) = eval(sprintf('d_%d(5);', i));
    osp(i-1) = eval(sprintf('d_%d(6);', i));
end
con = linspace(2, 7, 6);
figure();
plot(con, imp, con, omp, con, isp, con, osp)
legend('Inner midplane', 'Outer midplane', 'Inner strike point', 'Outer strike point')
ylabel('Displacement (cm)')