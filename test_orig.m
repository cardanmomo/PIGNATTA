% Test the finding and extrapolating of points along the LCFS for testing
%the control of the plasma via virtual circuits

%close all
clear all

equilibria='/projects/physics/MAST-U/Matfiles/2010/SXD/conventional.mat'
load(equilibria)
jprofile=get(equil, 'jprofile');
control=get(equil, 'control');
control = set(control,'diagnose',0);
control = set(control,'quiet',1);
feedback=get(equil, 'feedback');

%define limiter
plate=fiesta_line('plate', [0.333,0.333,1.09,1.35,1.73], [-1.1,-1.303,-2.06,-2.06,-1.68]);
xplate=[0.333,0.333,1.09,1.35,1.73];
yplate=[-1.1,-1.303,-2.06,-2.06,-1.68];
plt=cat(1,xplate,yplate);

%get x point and boundary, extract the LCFS
xpt=get(equil, 'xpoint')
boundary=get(equil, 'boundary')
r_lcfs=get(boundary, 'r');
z_lcfs=get(boundary, 'z');
psin=get(equil, 'Psi_n')
[xy,cc]=contour(psin, [0.999]);
r_bnd=xy(1,:);
z_bnd=xy(2,:);
r_bnd_cut=r_bnd(r_bnd>0 & r_bnd<2.0 & z_bnd>-2.5 & z_bnd<2.5);
z_bnd_cut=z_bnd(r_bnd>0 & r_bnd<2.0 & z_bnd>-2.5 & z_bnd<2.5);
% make row matrix of the values
separatrix=cat(1,r_bnd_cut, z_bnd_cut);
%find the intersections
[x_btm,y_btm,c,d]=intersections(r_bnd_cut, z_bnd_cut, xplate, yplate);
[x_top,y_top,c1,d1]=intersections(r_bnd_cut, z_bnd_cut, xplate, (-1.0)*yplate);

% find the midplane intersections
xmid=[0,2];
zmid=[0,0];
[x_mid,y_mid,c,d]=intersections(r_lcfs, z_lcfs, xmid, zmid);

%decimate the boundary to give some other control points
select=linspace(1, numel(r_lcfs), 10);
select=cast(select,'uint8');

r_vals=r_lcfs(select);
z_vals=z_lcfs(select);

%plot the results of the control points
plot(equil)
plotmastuoutline
plot(x_btm, y_btm, 'ro')
plot(x_top, y_top, 'ro')
plot(xpt, 'ro')
plot(get(xpt, 'r'), (-1.0)*get(xpt, 'z'), 'ro')
plot(x_mid, y_mid, 'ro')
plot(r_vals, z_vals, 'ro')

%define a fiesta point for this
br=get(equil, 'Br');
bz=get(equil, 'Bz');
pt=fiesta_point('test_point', 0.7382,1.1297);

%get the br and bz at the point
br_pt=interp2(br, pt);
bz_pt=interp2(bz, pt);
%get the gradient and find the equation of the line 
grad=bz_pt/br_pt;
intp=1.1297-(grad*0.7382);

%normal
ngrad=(-1.0*(1/grad));
nintp=1.1297-(ngrad*0.7382);

x=linspace(0,2,100);
y=(grad*x)+intp;
ny=(ngrad*x)+nintp;

plot(x,y)
plot(x,ny)

%now need to make a virtual circuit
%take the strike point one using dp, D2 and D3
i_strike=2e3;

coilset=get(config, 'coilset');
mixer=zeros(get(coilset, 'n'), 11);
mixer(coilset.p1, 1)=1;
mixer(coilset.p4, 2)=1;
mixer(coilset.p5, 3)=1;
mixer(coilset.p6, 4)=1;
mixer(coilset.pc, 5)=1;
mixer(coilset.px, 6)=1;
mixer(coilset.d1, 7)=1;
mixer([coilset.dp, coilset.d2, coilset.d3], 8)=[-0.15,-0.6,1.0]';
mixer(coilset.d5, 9)=1;
mixer(coilset.d6, 10)=1;
mixer(coilset.d7, 11)=1;

coilset_orig=coilset;
coilset=set(coilset, 'matrix', mixer);
irod=get(equil, 'irod');

icoil_mix=fiesta_icoil(coilset);
icoil_orig=get(equil, 'icoil');

icoil_mix.p1=0;%icoil_orig.p1;
icoil_mix.p4=0;%icoil_orig.p4;
icoil_mix.p5=0;%icoil_orig.p5;
icoil_mix.p6=0;%icoil_orig.p6;
icoil_mix.pc=0;%icoil_orig.pc;
icoil_mix.px=0;%icoil_orig.px;
icoil_mix.d1=0;%icoil_orig.d1;
icoil_mix.d5=0;%icoil_orig.d5;
icoil_mix.d6=0;%icoil_orig.d6;
icoil_mix.d7=0;%icoil_orig.d7;
icoil_mix.M1=i_strike;

icoil_in=fiesta_icoil(coilset_orig, get(icoil_mix, 'currents')*mixer');

icoil_total=icoil_orig+icoil_in;
icoil_total.p1=icoil_orig.p1;

%turn off the radial f/b - otherwise the P4 and P5 currents are fedback
%doesn't seem to work - does not converge when this turned off

zpos_sensor=fiesta_sensor_isoflux('zpos', [1.0,1.0]', [-1.1,1.1]')
feedback_z = fiesta_feedback2(get(config,'grid'), get(config,'coilset'), 'p6', zpos_sensor);

%feedback=set(feedback, 'off');
%feedback=set(feedback, 'vertical', 0.0);

equil_mix_vacuum=fiesta_equilibrium('Mixer vacuum', config, irod, icoil_in);

equil_final=set(equil,config,'feedback',feedback_z,'control',control);
equil_final=set(equil, config, 'icoil', icoil_total)

%equil_mix=fiesta_equilibrium('Mixer', config, irod, ...
%							jprofile, control, ...
%							feedback, icoil_total);

figure(config)
plot(equil, 'Psi_n', [1.0:0.05:1.2], 'b', 'Linewidth', 1)
plot(equil_final, 'Psi_n', [1.0:0.05:1.2], 'r', 'Linewidth', 1)
plot(config)
plotmastuoutline
