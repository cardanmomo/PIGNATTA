function s = fastParallelCalcSensitivityColumn(dataFileName, coilName)%sMat, equil, caller, coilName, outputFileName)
%#function fiesta_praia
%#function zame_sMat
%#function zame_mastuEq
%#function zame_params
%#function zame_container   
%#function zame_equil   
%#function zame_mastEq
%#function zame_ctrlSeg     
%#function zame_gap     
%#function zame_ctrlSegSet  
%#function zame_gapSet  
%#function fiesta_equilibrium
%#function fiesta_configuration
%#function fiesta_jprofile
%#function fiesta_jprofile_lao
%#function fiesta_icoil
%#function fiesta_grid
%#function fiesta_field
%#function fiesta_efit_configuration
%#function fiesta_feedback0
%#function fiesta_feedback1
%#function fiesta_feedback2
%#function fiesta_feedback3
%#function fiesta_feedback4
%#function fiesta_feedback5
%#function fiesta
%#function fiesta_circuit
%#function fiesta_coil
%#function fiesta_coilcase
%#function fiesta_coilset
%#function fiesta_configuration
%#function fiesta_control
%#function fiesta_efit_configuration
%#function fiesta_equilibrium
%#function fiesta_extra
%#function fiesta_extragrid
%#function fiesta_feedback
%#function fiesta_feedback0
%#function fiesta_feedback1
%#function fiesta_feedback2
%#function fiesta_feedback3
%#function fiesta_feedback4
%#function fiesta_feedback5
%#function fiesta_field
%#function fiesta_filament
%#function fiesta_graphic
%#function fiesta_grid
%#function fiesta_icoil
%#function fiesta_jprofile
%#function fiesta_jprofile_duck
%#function fiesta_jprofile_lao
%#function fiesta_jprofile_menard
%#function fiesta_jprofile_spline
%#function fiesta_jprofile_topeol2
%#function fiesta_loadassembly
%#function fiesta_passive
%#function fiesta_praia
%#function fiesta_randomgrid
%#function fiesta_rzip_configuration
%#function fiesta_sensor
%#function fiesta_sensor_br
%#function fiesta_sensor_btheta
%#function fiesta_sensor_bz
%#function fiesta_sensor_configuration
%#function fiesta_sensor_diamag
%#function fiesta_sensor_flux
%#function fiesta_sensor_isoflux
%#function fiesta_sensor_j
%#function fiesta_sensor_pressure
%#function fiesta_sensor_q
%#function fiesta_split_filament
%#function fiesta_vessel
%#function fiesta_point
%#function fiesta_jprofile_wire
%#function fiesta_line
%#function fiesta_sensor_dbrdr
%#function fiesta_sensor_dbrdz
%#function fiesta_sensor_dbzdz
%#function fiesta_tube_filament

    disp('fastParallelCalcSensitivityColumn')
    disp('--- PATH ---')
    path
    data = load(dataFileName)
    disp(data)
    data.sMat
    
    [equilibria, perturbations] = generateCoilPertEqs(data.sMat, data.equil, coilName, '');
    s = calculateCoilSensitivity(data.sMat, data.equil, coilName, equilibria, perturbations, '');
    
    outputFileName = [dataFileName,'_coil_',coilName,'.mat']

    save(outputFileName, 's');
end
