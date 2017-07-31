% Test the finding and extrapolating of points along the LCFS for testing
%the control of the plasma via virtual circuits

%close all
clear all

equilibria='/projects/physics/MAST-U/Matfiles/2016/Conventional_2014_P4_CATIA.mat';
%equilibria='/projects/physics/MAST-U/Matfiles/2016/Super_X_2014_P4_CATIA.mat';
load(equilibria)
control = get(equil, 'control');
control = set(control,'diagnose',0);  % Supresses animation
control = set(control,'quiet',1);  % Supresses other messages
feedback=get(equil, 'feedback');

[x_control, y_control]=control_pointsV2(equil);

% Some other control points (10 around boundary)

boundary=get(equil, 'boundary');
r_lcfs=get(boundary, 'r');
z_lcfs=get(boundary, 'z');
select=linspace(1, numel(r_lcfs), 10);
select=cast(select,'uint8');
r_vals=r_lcfs(select);
z_vals=z_lcfs(select);

%define a fiesta point for analysis
br=get(equil, 'Br');
bz=get(equil, 'Bz');
p_x=r_vals(7);
p_y=z_vals(7);
pt=fiesta_point('test_point', p_x, p_y);

%get the br and bz at the point
br_pt=interp2(br, pt);
bz_pt=interp2(bz, pt);
%get the gradient and find the equation of the line 
grad=bz_pt/br_pt;
intp=p_y-(grad*p_x);

%normal
ngrad=(-1.0*(1/grad));
nintp=p_y-(ngrad*p_x);

x=linspace(0,2,100);
y=(grad*x)+intp;
ny=(ngrad*x)+nintp;


%now need to make a virtual circuit
%take the strike point one using dp, D2 and D3
i_strike=-2.0e3;

coilset=get(config, 'coilset');
mixer=zeros(get(coilset, 'n'), 10);
mixer(coilset.p1, 1)=1;
mixer(coilset.p4, 2)=1;
mixer(coilset.p5, 3)=1;
mixer(coilset.p6, 4)=1;
mixer(coilset.pc, 5)=1;
mixer(coilset.px, 6)=1;
mixer(coilset.d1, 7)=1;
mixer([coilset.dp, coilset.d2, coilset.d3, coilset.d5], 8)=[0.15,-0.6,1.0, 2.7]'; 
%mixer(coilset.d5, 9)=1;
mixer(coilset.d6, 9)=1;
mixer(coilset.d7, 10)=1;

coilset_orig=coilset;
coilset=set(coilset, 'matrix', mixer);
irod=get(equil, 'irod');

icoil_mix=fiesta_icoil(coilset);
icoil_orig=get(equil, 'icoil');

icoil_mix.p1=icoil_orig.p1;
icoil_mix.p4=icoil_orig.p4;
icoil_mix.p5=icoil_orig.p5;
icoil_mix.p6=icoil_orig.p6;
icoil_mix.pc=icoil_orig.pc;
icoil_mix.px=icoil_orig.px;
icoil_mix.d1=icoil_orig.d1;
icoil_mix.M1=i_strike;
%icoil_mix.d5=0;%icoil_orig.d5;
icoil_mix.d6=icoil_orig.d6;
icoil_mix.d7=icoil_orig.d7;

icoil_in=fiesta_icoil(coilset_orig, get(icoil_mix, 'currents')*mixer');

icoil_total=icoil_orig+icoil_in;
icoil_total.p1=icoil_orig.p1;
icoil_total.p6=icoil_orig.p6;

%turn off the radial f/b - otherwise the P4 and P5 currents are fedback
%doesn't seem to work - does not converge when this turned off

zpos_sensor = fiesta_sensor_isoflux('zpos', [1.0,1.0]', [-1.1,1.1]');
feedback_z = fiesta_feedback2(get(config,'grid'), get(config,'coilset'), 'p6', zpos_sensor);

%feedback=set(feedback, 'off');
%feedback=set(feedback, 'vertical', 0.0);

%equil_mix_vacuum = fiesta_equilibrium('Mixer vacuum', config, irod, icoil_in);
equil_final=set(equil,config,'feedback',feedback_z,'control',control);
equil_final=set(equil,config,'icoil',icoil_total,'control', control);
[x_control_final, y_control_final]=control_pointsV2(equil_final);

% Calculate equilibrium with a different jprofile
jprofile=get(equil, 'jprofile');
%jprofile=fiesta_jprofile_lao('cust', 1e6);
%equil_final=set(equil_final, config, 'jprofile', jprofile);

equil_mix=fiesta_equilibrium('Mixer', config, irod, jprofile, control, feedback, icoil_total);

%figure(config)
%plot(equil, 'Psi_n', [1.0:0.05:1.2], 'b', 'Linewidth', 1)
plot(equil, 'psi_boundary', 'b')
hold on
plot(config)
plot(equil_final, 'psi_boundary', 'r')
%plot(equil_final, 'Psi_n', [1.0:0.05:1.2], 'r', 'Linewidth', 1)
%plot(equil_mix, 'Psi_n', [1.0:0.05:1.2], 'm', 'Linewidth', 1)=
plot(x_control, y_control, 'ro')
plot(x_control_final, y_control_final, 'ro')
plot(r_vals, z_vals, 'ro');
plot(x,y)
plot(x,ny)
plotmastuoutline