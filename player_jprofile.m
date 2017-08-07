% Script to play with coefficients alpha and beta of the jprofile function

% Original:
uno_a =     [0.20732688478800,  -1.81044829291000,  5.18631892098000,   -4.78976762426000]  *1e7;
uno_b =     [-1.39852,      20.0825,        -65.737,        77.5454];

% Your try:
dos_a =     [0.4,               -3,                 10,                 -9]                 *1e7;
tres_a =    [0.5,               -2.9,               9,                  -8]                 *1e7;
cuatro_a =  [0.6,               -2.8,               8,                  -7]                 *1e7;
cinco_a =   [0.7,               -2.7,               7,                  -6]                 *1e7;
seis_a =    [0.8,               -2.6,               6,                  -5]                 *1e7;
siete_a =   [0.9,               -2.5,               5,                  -4]                 *1e7;

dos_b =     [-2.7,          40,             -131,           155];
tres_b =    [-2.5,          35,             -120,           140];
cuatro_b=   [-2.1,          30,             -110,           135];
cinco_b =   [-2,          25,             -100,           130];
seis_b =    [-1.7,          20,             -90,            125];
siete_b =   [-1.5,          15,             -80,            120];

uno = uno_a./uno_b;
dos = dos_a./dos_b;
tres = tres_a./tres_b;
cuatro = cuatro_a./cuatro_b;
cinco = cinco_a./cinco_b;
seis = seis_a./seis_b;
siete = siete_a./siete_b;

plot([uno(1), dos(1), tres(1), cuatro(1), cinco(1), seis(1), siete(1)])
hold on
plot([uno(2), dos(2), tres(2), cuatro(2), cinco(2), seis(2), siete(2)], 'r')
plot([uno(3), dos(3), tres(3), cuatro(3), cinco(3), seis(3), siete(3)], 'g')
plot([uno(4), dos(4), tres(4), cuatro(4), cinco(4), seis(4), siete(4)], 'm')
legend('uno', 'dos', 'tres', 'cuatro')

jprofile2=fiesta_jprofile_lao('testj2', dos_a, dos_b, 1, Ip);  % Create the profile according to coefficients
equil_j2=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile2, control_efit, ...
	efit_config, icoil, obs, weights)  % Calculate equil
j = get(equil, 'j');  % Original jprofile at the midplane
j2 = get(equil_j2, 'j');
[r, V] = section(j);  % Get J profile at the midplane
[r, Vj2] = section(j2);

jprofile3=fiesta_jprofile_lao('testj3', tres_a, tres_b, 1, Ip);
equil_j3=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile3, control_efit, ...
	efit_config, icoil, obs, weights)
j3 = get(equil_j3, 'j');
[r, Vj3] = section(j3);

jprofile4=fiesta_jprofile_lao('testj4', cuatro_a, cuatro_b, 1, Ip);
equil_j4=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile4, control_efit, ...
	efit_config, icoil, obs, weights)
j4 = get(equil_j4, 'j');
[r, Vj4] = section(j4);

jprofile5=fiesta_jprofile_lao('testj5', cinco_a, cinco_b, 1, Ip);
equil_j5=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile5, control_efit, ...
	efit_config, icoil, obs, weights)
j5 = get(equil_j5, 'j');
[r, Vj5] = section(j5);

jprofile6=fiesta_jprofile_lao('testj6', seis_a, seis_b, 1, Ip);
equil_j6=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile6, control_efit, ...
	efit_config, icoil, obs, weights)
j6 = get(equil_j6, 'j');
[r, Vj6] = section(j6);

jprofile7=fiesta_jprofile_lao('testj7', siete_a, siete_b, 1, Ip);
equil_j7=fiesta_equilibrium(...
	'Conventional fx const.', config, irod, jprofile7, control_efit, ...
	efit_config, icoil, obs, weights)
j7 = get(equil_j7, 'j');
[r, Vj7] = section(j7);

% For the jprofile vs psi_n plots
psi_j=linspace(0, 1,100);
sens_j=fiesta_sensor_j('jsensor', 'psi_n', psi_j);
j_prof=interp2(equil, sens_j);
j_prof2=interp2(equil_j2, sens_j);
j_prof3=interp2(equil_j3, sens_j);
j_prof4=interp2(equil_j4, sens_j);
j_prof5=interp2(equil_j5, sens_j);
j_prof6=interp2(equil_j6, sens_j);
j_prof7=interp2(equil_j7, sens_j);

test_plotter