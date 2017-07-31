%Program to adjust current profile to allow investigation of the impact of li
%on the control

%close all
%clear all

%load('/common/projects/physics/MAST-U/Matfiles/2016/conventional_400kA_high_li.mat')
load 2016/Super_X_2014_P4_CATIA_400kA;

irod=get(equil, 'irod');
control=get(equil, 'control');
feedback=get(equil, 'feedback');
icoil=get(equil, 'icoil');
jprofile=get(equil, 'jprofile');

control = set(control,'diagnose',0);
control = set(control,'quiet',1);
modif = 1;

control = fiesta_control('boundary_method', 2);
control = set(control,'diagnose',0);
control = set(control,'quiet',1);
inputs={coilset};
efit_config=fiesta_efit_configuration(grid, inputs, outputs, ...
    free_inputs, relaxation_parameter);

equil_new=fiesta_equilibrium('test', config, irod, ...
							jprofile, control, efit_config, icoil, obs, weights)

%get the values of the j profile at the normalised flux locations
psi_j=linspace(0, 1,100);
psi_z=psi_j;
psi_z(:)=0;
j = get(equil, 'j');
[r, V] = section(j);

%make fiesta sensor to get the j at these points
sens_j=fiesta_sensor_j('jsensor', 'psi_n', psi_j);

j_prof=interp2(equil, sens_j);

%now change the profile and see what the effect is. Have to re-run it through
%the equilibrium so that the normalisation for the current is performed.

%want flat edge on to minimise current outside LCFS - GC says makes compiling
%better
%input alpha (pp) and beta (ff') parameters 
%magnitudes change the profile shape - so more [a,b,c] are entered for each
%with these being the coeffs infront of the polynomial for the curve
%Larger coeffs at higher coeffs gives more current in the outer part of the 
%profile - lower li in theory.

%the alpha values affect the pressure, so the beta of the plasma is determined
%by these - they need to be 1e6 or so larger than the beta values
%conserve the beta poloidal between all of the configurations.

Ip = 400e3;

dos_a =     [0.5,   1,      2]  *0.4e6;
tres_a =    [0.25,  1.5,    3]  *0.33e6;
cuatro_a =  [1,     1,      1]  *0.65e6;
cinco_a =   [4,     2,      1]  *0.75e6;
seis_a =    [4,     2       ]   *1.0e6;
siete_a =   [0.1,   0.1     ]   *1.75e6;

dos_b =     [0.25,  0.5,    1];
tres_b =    [0.25,  0.5,    1.];
cuatro_b=   [0.5,   0.5,    0.5];
cinco_b =   [2,     1,      0.5];
seis_b =    [2,     1];
siete_b =   [0.1,   0.1];

jprofile2=fiesta_jprofile_lao('testj2', dos_a, dos_b, 1, Ip);
equil_j2=fiesta_equilibrium('test2', config, irod, ...
							jprofile2, control, efit_config, icoil, obs, weights)
j_prof2=interp2(equil_j2, sens_j);


jprofile3=fiesta_jprofile_lao('testj3', tres_a, tres_b, 1, Ip);
equil_j3=fiesta_equilibrium('test3', config, irod, ...
							jprofile3, control, efit_config, icoil, obs, weights)
j_prof3=interp2(equil_j3, sens_j);


jprofile4=fiesta_jprofile_lao('testj4', cuatro_a, cuatro_b, 1, Ip);
equil_j4=fiesta_equilibrium('test4', config, irod, ...
							jprofile4, control, efit_config, icoil, obs, weights)
j_prof4=interp2(equil_j4, sens_j);

jprofile5=fiesta_jprofile_lao('testj5', cinco_a, cinco_b, 1, Ip);
equil_j5=fiesta_equilibrium('test5', config, irod, ...
							jprofile5, control, efit_config, icoil, obs, weights)
j_prof5=interp2(equil_j5, sens_j);

jprofile6=fiesta_jprofile_lao('testj6', seis_a, seis_b, 1, Ip);
equil_j6=fiesta_equilibrium('test6', config, irod, ...
							jprofile6, control, efit_config, icoil, obs, weights)
j_prof6=interp2(equil_j6, sens_j);

jprofile7=fiesta_jprofile_lao('testj7', siete_a, siete_b, 1, Ip);
equil_j7=fiesta_equilibrium('test7', config, irod, ...
							jprofile7, control, efit_config, icoil, obs, weights)
j_prof7=interp2(equil_j7, sens_j);

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
