function [drsep, conn_len, flux_exp, pitch_tgt, pitch_mid,leg_length]=calc_cl(equil)

%adapted from make_cl_plot.m
%Program to make aconnection length plot across the outboard edge in FIESTA

%equilibria='/projects/physics/MAST-U/Matfiles/2010/SXD/conventional.mat'
%equilibria='/projects/physics/MAST-U/Matfiles/2014/Super_X_2014.mat'
%load(equilibria);

%define the target that intersects the flux surfaces
plate=fiesta_line('plate', ...
				[0.333,1.09,1.35,1.73,1.555,...
				0.8902,0.8548,0.8273,0.8197,0.8223,0.8398, 0.8694, ...
				1.19], ...
				[-1.303,-2.06,-2.06,-1.68,...
				-1.567,-1.589,-1.57,-1.532,-1.494,-1.445,-1.383,-1.331, ...
				-1.007]);

%define the radii across which the CL is required
%find the outboard midplane radius
bnd=get(equil, 'boundary');
rbnd=get(bnd, 'r');
zbnd=get(bnd, 'z');
[rlcfs_mid,ind]=max(rbnd);
zlcfs_mid=zbnd(ind);

%now from the LCFS location, go out a given distance dr
dr=0.005; %5 mm say
drsep=linspace(0.00, dr, 100);
r_mid=drsep+rlcfs_mid;
z_mid=r_mid;
z_mid(:)=zlcfs_mid;

%26/04 - add ability to calc r,z plane leg length
% trace from the lower xpoint
[r_xpt1,z_xpt1,r_xpt2,z_xpt2]=xpoints(equil);
if z_xpt1 < z_xpt2
	zxpt=z_xpt1;
	rxpt=r_xpt1;
end
if  z_xpt2 < z_xpt1
	zxpt=z_xpt2;
	rxpt=r_xpt2;
end
%26.04 mods end

%now using the r locations from the midplane, get the psi at these points
psi_points=interp2(get(equil, 'Psi'), r_mid, z_mid);

%now loop on the elements of psi_points to get the connection length
conn_len=zeros(1,numel(psi_points));
r_tgt=zeros(1,numel(psi_points));
z_tgt=zeros(1,numel(psi_points));
s_tgt=zeros(1,numel(psi_points));
leg_length=zeros(1,numel(psi_points)); %line 26/04 mod

for i=1:numel(psi_points)
	[length_3d, length_2d, conn, phi, ...
	path_3d, path_2d, seg1, seg2]=connection_length3(equil, ...
													psi_points(i), plate);

	%26/04 mod
	if numel(length_3d) ~= 0
		%calculate the leg length in the R,Z plane from the Xpoint down
		rf=get(conn, 'r');
		zf=get(conn, 'z');
		%cut to those below the X point
		loc=(zf <= zxpt);
		r_leg=rf(loc);
		z_leg=zf(loc);

		leg_length_tmp=0;

		for j=1:numel(r_leg)-1
				leg_length_tmp=leg_length_tmp+sqrt((r_leg(j+1)-r_leg(j))^2+...
												(z_leg(j+1)-z_leg(j))^2);
		end

		leg_length(i)=leg_length_tmp;
	else
		leg_length(i)=0;
	end	
	%26/04 mod end

	if numel(length_3d) ~= 0 
		conn_len(i)=length_3d;
	else
		conn_len(i)=0;
	end

	%get the end point of the field line - provided there is a result ret'd
	if numel(length_3d) ~= 0
		rpath=get(conn, 'r');
		zpath=get(conn, 'z');
		r_tgt(i)=rpath(numel(rpath));
		z_tgt(i)=zpath(numel(zpath));
		if i >= 2
			s_tgt(i)=((r_tgt(i)-r_tgt(i-1)).^2+ ... 
									(z_tgt(i)-z_tgt(i-1)).^2).^(0.5)+...
									s_tgt(i-1);
			if r_tgt(i-1) == 0
				s_tgt(i)=0;
			end
		end
	end
end

flux_exp=s_tgt./drsep; %this is the flux exp at the actual target as calculated
					%as the distance between the intersection of the field line
					%and the line defining the tiles
figure()
plot(drsep, conn_len)
xlabel('dr from separatrix (m)')
ylabel('connection length (m)')
%conn_len
%flux_exp
%now want to determine the B field components at the point where each field 
%line strikes the divertor surface
%get the fields
br=get(equil, 'Br');
bz=get(equil, 'Bz');
bphi=get(equil, 'Bphi');
btheta=get(equil, 'Bp');

%now interpolate the values onto the R,Z points from the field line tracing
br_tgt=interp2(br, r_tgt, z_tgt);
bz_tgt=interp2(bz, r_tgt, z_tgt);
bphi_tgt=interp2(bphi, r_tgt, z_tgt);
btheta_tgt=interp2(btheta, r_tgt, z_tgt);
btotal_tgt=sqrt(br_tgt.^2+bz_tgt.^2+bphi_tgt.^2);

%repeat for the midplane
br_mid=interp2(br, r_mid, z_mid);
bz_mid=interp2(bz, r_mid, z_mid);
bphi_mid=interp2(bphi, r_mid, z_mid);
btheta_mid=interp2(btheta, r_mid, z_mid);
btotal_mid=sqrt(br_mid.^2+bz_mid.^2+bphi_mid.^2);

%calculate the target pitch angle using the method from Loarte NF 1992
pitch_tgt=asin(abs(btheta_tgt)./btotal_tgt) %19/04/17 - shouldn't these be asin?
pitch_mid=asin(abs(btheta_mid)./btotal_mid)

%figure

%subplot(2,2,1);
%plot(drsep, conn_len)
%title(equilibria)

%subplot(2,2,2);
%plot(drsep, flux_exp)

%subplot(2,2,3);
%plot(drsep, pitch_tgt*(180/3.142))
%axis([0,0.05, 0, 15])
%hold on
%plot(drsep, pitch_mid*(180/3.142)/10, 'g')
%hold off

%text(0.01, 4, ['alpha(tgt)=' num2str(pitch_tgt(2)*(180/3.142))])
%text(0.01, 3, ['alpha(mid)=' num2str(pitch_mid(2)*(180/3.142))])

%subplot(2,2,4);
%plot(r_tgt, z_tgt, 'o')
%axis([0,2,-2.5,0]);

%text(0.1, -0.20, ['R(tgt)=' num2str(r_tgt(2))])
%text(0.1, -0.50, ['R(mid)=' num2str(r_mid(2))])
%text(0.1, -0.80, ['Btheta(mid)=' num2str(btheta_mid(2))])
%text(0.1, -1.10, ['Btheta(div)=' num2str(btheta_tgt(2))])
%text(0.1, -1.40, ['Bphi(mid)=' num2str(bphi_mid(2))])
%text(0.1, -1.70, ['Bphi(div)=' num2str(bphi_tgt(2))])
%text(0.1, -2.00, ['Btotal(mid)=' num2str(btotal_mid(2))])
%text(0.1, -2.30, ['Btotal(div)=' num2str(btotal_tgt(2))])

%end
