%script for adjusting coil current in matlab

%load the equilbrium of interest
%load('/projects/physics/MAST-U/Matfiles/2014/Super_X_2014.mat')

fn=fopen('adjust_param.txt');
tline=fgets(fn);
path=tline(6:end-1)
load(path)

%read in the next 12 lines
values=zeros(1,15);

for i=1:15
	tline=fgets(fn);
	[tag,value]=strtok(tline, ' ');
	values(i)=str2num(value);
end

fclose(fn);

%extract the coil currents
icoil_new=get(equil, 'icoil')

%assign the coil currents
limit=100;
if (abs(values(1)) < limit) icoil_new.p1=icoil_new.p1*values(1);else icoil_new.p1=values(1); end
if (abs(values(2)) < limit) icoil_new.p4=icoil_new.p4*values(2);else icoil_new.p4=values(2); end
if (abs(values(3)) < limit) icoil_new.p5=icoil_new.p5*values(3);else icoil_new.p5=values(3); end
if (abs(values(4)) < limit) icoil_new.px=icoil_new.px*values(4);else icoil_new.p1=values(4); end
if (abs(values(5)) < limit) icoil_new.d1=icoil_new.d1*values(5);else icoil_new.d1=values(5); end
if (abs(values(6)) < limit) icoil_new.d2=icoil_new.d2*values(6);else icoil_new.d2=values(6); end
if (abs(values(7)) < limit) icoil_new.d3=icoil_new.d3*values(7);else icoil_new.d3=values(7); end
if (abs(values(8)) < limit) icoil_new.d5=icoil_new.d5*values(8);else icoil_new.d5=values(8); end
if (abs(values(9)) < limit) icoil_new.d6=icoil_new.d6*values(9);else icoil_new.d6=values(9); end
if (abs(values(10)) < limit) icoil_new.d7=icoil_new.d7*values(10);else icoil_new.d7=values(10); end
if (abs(values(11)) < limit) icoil_new.dp=icoil_new.dp*values(11);else icoil_new.dp=values(11); end
if (abs(values(12)) < limit) icoil_new.pc=icoil_new.pc*values(12);else icoil_new.pc=values(12); end
if (abs(values(13)) < limit) icoil_new.p6=icoil_new.p6*values(13);else icoil_new.p6=values(13); end

% change the outer radius contraint location from R=1.35m
fb=get(equil, 'feedback');
r_current=get(fb, 'r');
z_current=get(fb, 'z');
if (values(14) ~= r_current) fb=set(fb, 'r', values(14));end
if (values(15) ~= z_current) fb=set(fb, 'z', values(15));end
icoil_new

%turn off the radial feedback
fb2=set(fb, 'off') %turns off everything
fb3=set(fb2, 'vertical', 0) % turns vertical back on

%recreate the equilibrium
%equil_new=fiesta_equilibrium('test', config, get(equil,'irod'),...
%                                            get(equil,'jprofile'), ...
%                                            get(equil,'control'), ...
%                                            get(equil,'feedback'), ...
%                                            icoil_new);
equil_new=fiesta_equilibrium('test', config, get(equil,'irod'),...
                                            get(equil,'jprofile'), ...
                                            get(equil,'control'), ...
                                            fb3, ...
                                            icoil_new);
icoil_converged=get(equil_new, 'icoil');

icoil_converged

%plot the result
figure()
%plot(equil_new, 'psi', [1.05,1.1,1.15,1.20], 'Linecolor',[0,0,1])
plot(equil_new, 'psi_boundary', 'r')
plot(equil, 'psi_boundary', 'k')

plot(config);

surfaces = divertor_geometry_13_09_06_P6_DivSOL_jrh;
plot(surfaces.r, surfaces.z)
plot(surfaces.r, (-1.0)*surfaces.z)
