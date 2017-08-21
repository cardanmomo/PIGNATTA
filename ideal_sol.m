%Ideal solenoid correction from GF - CD/MU/00131

%tidy up
clear all
close all

%take this and test it for a few timeslices

%lets start with a SXD
%load('/projects/physics/MAST-U/Matfiles/2014/Super_X_2014_P4_CATIA.mat');
%load('/projects/physics/MAST-U/Matfiles/2010/SXD/conventional.mat')
%load('/common/projects/physics/MAST-U/Matfiles/2016/Conventional_2014_P4_CATIA.mat')
load('/common/projects/physics/MAST-U/Matfiles/2016/Super_X_2014_P4_CATIA.mat')

%get the coil currents for this config, which is at zero P1
icoil=get(equil, 'icoil');
ip=get(equil, 'Ip');
n_coils=get(icoil, 'n')

cols={'k', 'r', 'g', 'b', 'c'};

%define constants for the ideal solenoid
const=[-191,23,-575,-74,-3,-20,-42,-20,108,-78];
a_1=[-0.014,0.002,0.033,0.169,0.113,0.115,0.110,0.032,-0.067,0.001];
b_1=[-0.0174,-0.006,0.0031,0.0023,0.0004,0.0009,0.0024,0.0026,0.0051,0.0009];
c_1=[0.148,-0.031,-0.021,0.003,0.134,0.033,0.033,0.008,-0.115,-0.163];

%calculate the sol thickness for the current equilibrium - use D1
delta_sol_calc=(icoil.p4-const(1)-(a_1(1)*icoil.p1)-(b_1(1)*ip))/(c_1(1)*ip);

%now calculate the coil currents at a number of phases of the solenoid flux
p1_vals=[30,25,20,15,10,5,0,-5,-9,-15,-20,-25,-30,-35,-40,-45]*1e3;
%p1_vals=[0,0,0,0,0];
delta_sol=zeros(1, numel(p1_vals));
delta_sol(:)=delta_sol_calc;

%delta_sol=[delta_sol_calc*0.5, delta_sol_calc*0.75, delta_sol_calc, ...
%			delta_sol_calc*1.25, delta_sol_calc*1.5];

%make array for the output
coil_currents=zeros(n_coils, numel(p1_vals));

for i=1:numel(p1_vals)
	%write the p1 val into the coil currents array
	coil_currents(1,i)=p1_vals(i);
	for j=2:n_coils-2
		coil_currents(j,i)=const(j-1)+ ...
							(a_1(j-1)*p1_vals(i))+ ...
							(b_1(j-1)*ip)+ ...
							(c_1(j-1)*delta_sol(i)*ip);
	end
end
coil_currents_initial=coil_currents;

%work out the difference between the icoil and the predicted values
loc=(p1_vals == icoil.p1);
if sum(loc) > 1 
	loc(:)=0;
	loc(1)=1;
end
dcoil_0=zeros(n_coils, 1);

dcoil_0(2,1)=icoil.p4-coil_currents(2,loc);
dcoil_0(3,1)=icoil.p5-coil_currents(3,loc);
dcoil_0(4,1)=icoil.px-coil_currents(4,loc);
dcoil_0(5,1)=icoil.d1-coil_currents(5,loc);
dcoil_0(6,1)=icoil.d2-coil_currents(6,loc);
dcoil_0(7,1)=icoil.d3-coil_currents(7,loc);
dcoil_0(8,1)=icoil.d5-coil_currents(8,loc);
dcoil_0(9,1)=icoil.d6-coil_currents(9,loc);
dcoil_0(10,1)=icoil.d7-coil_currents(10,loc);
dcoil_0(11,1)=icoil.dp-coil_currents(11,loc);

dcoil_currents=repmat(dcoil_0,1,numel(p1_vals));

coil_currents=coil_currents+dcoil_currents;

for i=1:numel(p1_vals)

index=i;

icoil_orig=icoil;
icoil.p1=coil_currents(1,index);
icoil.p4=coil_currents(2,index);
icoil.p5=coil_currents(3,index);
icoil.px=coil_currents(4,index);
icoil.d1=coil_currents(5,index);
icoil.d2=coil_currents(6,index);
icoil.d3=coil_currents(7,index);
icoil.d5=coil_currents(8,index);
icoil.d6=coil_currents(9,index);
icoil.d7=coil_currents(10,index);
icoil.dp=coil_currents(11,index);

coilset=get(config, 'coilset');
irod=get(equil,'irod');
jprofile=get(equil, 'jprofile');
feedback=fiesta_feedback1(coilset, {'p4', 'p5'}, 1.34, {'p6'}, 0.0)
control=get(equil, 'control');
grid=get(config, 'grid');
equil_index=fiesta_equilibrium(num2str(p1_vals(index)), ...
						config, irod, jprofile, ...
						control, feedback, icoil);

if i==1 
	equil_p1=equil_index;
end
if i>1 
	equil_p1=[equil_p1, equil_index];
end

end

close all
figure(config)
plot(equil_index)
plotmastuoutline

%extract from each of the equilbria, a flux plot and the coil currents
%required
i_p1=zeros(1,numel(p1_vals));
i_p4=zeros(1,numel(p1_vals));
i_p5=zeros(1,numel(p1_vals));
i_px=zeros(1,numel(p1_vals));
i_d1=zeros(1,numel(p1_vals));
i_d2=zeros(1,numel(p1_vals));
i_d3=zeros(1,numel(p1_vals));
i_d5=zeros(1,numel(p1_vals));
i_d6=zeros(1,numel(p1_vals));
i_d7=zeros(1,numel(p1_vals));
i_dp=zeros(1,numel(p1_vals));
i_pc=zeros(1,numel(p1_vals));

fig_folder='/home/cmoreno/work/ideal_sol_plots/'

figure(config)

for i=1:numel(p1_vals)

	ic=get(equil_p1(i), 'icoil');

	i_p1(i)=ic.p1;
	i_p4(i)=ic.p4;
	i_p5(i)=ic.p5;
	i_px(i)=ic.px;
	i_d1(i)=ic.d1;
	i_d2(i)=ic.d2;
	i_d3(i)=ic.d3;
	i_d5(i)=ic.d5;
	i_d6(i)=ic.d6;
	i_d7(i)=ic.d7;
	i_dp(i)=ic.dp;
	i_pc(i)=ic.pc;

%	set(fig, 'visible','off')
	tmp=get(equil_p1(i), 'Psi_n');
	tmp_data=get(tmp, 'data');
	contour(tmp, [1.00:0.1:1.1], 'linecolor', cols{i}, 'LineWidth', 2.) 
	%keyboard
	hold on
	plotmastuoutline
	%parametersshow(equil_p1(i))
	text(1.2,-1.-(i*0.1), ...
			['Delta sol: ' num2str(delta_sol(i)*1e2)], 'color', cols{i})

	fname=[fig_folder 'ideal_sol_' num2str(i) '.eps'];

	%hgexport(gcf, fname)
	print(fname,'-depsc2')

end

plot(config)

figure()
plot(i_p1/1e3, i_p4/1e3, 'b')
xlabel('P1 current (kA)')
ylabel('Coil current (kA)')
hold on
plot(i_p1/1e3, i_p5/1e3, 'k')
plot(i_p1/1e3, i_px/1e3, 'r')
plot(i_p1/1e3, i_d1/1e3, 'g')
plot(i_p1/1e3, i_d2/1e3, 'y')
plot(i_p1/1e3, i_d3/1e3, 'c')
plot(i_p1/1e3, i_d5/1e3, '-ok')
plot(i_p1/1e3, i_d6/1e3, '-ob')
plot(i_p1/1e3, i_d7/1e3, '-xk')
plot(i_p1/1e3, i_dp/1e3, '-or')
plot(i_p1/1e3, i_pc/1e3, '-og')

legend('P4','P5','Px','D1','D2','D3','D5','D6','D7','Dp','Pc')
