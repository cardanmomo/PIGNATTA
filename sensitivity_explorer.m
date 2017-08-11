% Program to analise current variations in terms of dismplacement (can be
% used for a sensitivity matrix or just a coil

%clear all

%first read back in the sensitivity matrix for a given config
%sfile='smat1.txt';
%sfile5='smat5.txt';
%sfile10='smat10.txt';
%sfile15='smat15.txt';
%sfile17='smat17.txt';
%sfile20='smat20.txt';
%sfile22='smat22.txt';
%sfile25='smat25.txt';
%sfile30='smat30.txt';
%sfile35='smat35.txt';
%sfile40='smat40.txt';
%sfile45='smat45.txt';
%sfile50='smat50.txt';
%sfile55='smat55.txt';

%data=importdata(sfile, ' ', 1);
%data5=importdata(sfile5, ' ', 1);
%data10=importdata(sfile10, ' ', 1);
%data15=importdata(sfile15, ' ', 1);
%data17=importdata(sfile17, ' ', 1);
%data20=importdata(sfile20, ' ', 1);
%data22=importdata(sfile22, ' ', 1);
%data25=importdata(sfile25, ' ', 1);
%data30=importdata(sfile30, ' ', 1);
%data35=importdata(sfile35, ' ', 1);
%data40=importdata(sfile40, ' ', 1);
%data45=importdata(sfile45, ' ', 1);
%data50=importdata(sfile50, ' ', 1);
%data55=importdata(sfile55, ' ', 1);

sfile0='smatrices/smatrix_400kA_conv_low_li.txt';  % Original smatrix SD
data0=importdata(sfile0, ' ', 1);

control_params=char(data0.textdata(2:end));
ncontrol=size(control_params, 1);
coil_ind_s={'p4', 'p5', 'px', 'd1', 'd2', 'd3', 'd5', 'd6', 'd7', 'dp', 'pc'};

%read in the equilbria
%equilibria='/projects/physics/MAST-U/Matfiles/2016/conventional_400kA.mat';
%equilibria='/projects/physics/MAST-U/Matfiles/2016/conventional_400kA_high_li.mat';
%equilibria='/projects/physics/MAST-U/Matfiles/2016/Super_X_2014_P4_CATIA.mat';
%equilibria='/projects/physics/MAST-U/Matfiles/2016/high_li_sxd_2014coils.mat';
%equilibria='/projects/physics/MAST-U/Matfiles/2016/Conventional_2014_P4_CATIA.mat';
%load(equilibria)
equil = equil_j2
equil_orig=equil;
irod=get(equil, 'irod');
control_points=['mid_in ','mid_out ','xp_low ', 'xp_up ','sp_in_low ', 'sp_out_low ','sp_in_up ','sp_out_up'];

coilset = get(config,'coilset');
control = get(equil,'control');
control = set(control,'diagnose',0);
control = set(control,'quiet',1);

[x_control, y_control, conn_len]=control_pointsV3(equil_orig);
% Isoflux sensor
iso = fiesta_sensor_isoflux('fbz_iso', [0.9,  0.9], [1.3, -1.3]);
icoil_orig=get(equil, 'icoil');
icoil_flux=icoil_orig;
che = 0;  % initializes determinator of config and mastoutline plot
path = '/home/cmoreno/work/';
smatrix=data0.data*(2.5);  %-----------------------------------------------------

for displ=0:45
    displ = -displ
    for control_p=6
        %calculate the change in the location of the control points
        [icoil_total]=v_circ_explorer(equil, coilset, smatrix, displ, control_p);

        % Introduce feedback & calculate first new equilibrium
        feedback=fiesta_feedback2(get(config,'grid'), coilset, 'p6', iso);
        equil_new=set(equil,config,'feedback',feedback,'control',control);
        equil_new=set(equil_new,config,'icoil',icoil_total);
        [x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);

        delta_x=x_control-x_control_vc;
        delta_y=abs(y_control)-abs(y_control_vc); %kludge for when the xpts are other way up
        delta_vc(control_p,:)=sqrt(delta_x.^2+delta_y.^2);
        params=parameters(equil_new);
        betap=params.betap;

        vals=fopen([path, 'dummy0.txt'], 'a');  %--------------------------
        fprintf(vals, '%f', displ);
        fprintf(vals, ' %f', conn_len_vc(1));
        fprintf(vals, ' %f', conn_len_vc(3));
        for j=1:numel(x_control)
            if j < numel(x_control)
                fprintf(vals, ' %f', delta_x(j));
            end
            if j == numel(x_control)
             fprintf(vals, ' %f\n', delta_x(j));
            end
        end
        fclose(vals);
        
        plot(equil_new, 'psi_boundary', 'r') 
        if che==0
            hold on
            plot(equil_orig, 'psi_boundary', 'b')
            plotmastuoutline;
            plot(config)        
        end 
        che = che + 1;
    end
end