%read in the existing version and update the coil set
load('/common/projects/physics/MAST-U/Matfiles/2013/High_li_Super_X_2012.mat')

save_data=1;

%get the new coils
new=load('/projects/physics/MAST-U/Matfiles/2014/Super_X_2014_P4_CATIA.mat');
equil_14=rescue(equil,config,new.config);
config=new.config;
equil=equil_14;

figure(config)
plot(equil)
parametersshow(equil)
plotmastuoutline_2016

path_to_save='/common/scratch/athorn/FIESTA/'

if save_data==1
	fname=[path_to_save 'high_li_sxd_2014coils.mat']
	save(fname, 'equil', 'config')
end
