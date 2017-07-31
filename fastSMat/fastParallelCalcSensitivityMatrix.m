function ret = fastParallelCalcSensitivityMatrix(sMat, equil)
% 
    disp('fastParallelCalcSensitivityMatrix start')
    ret = [];
%     disp('zame_equil.parallelCalcSensitivityMatrix')
    
    dataFileName = tempname;
    slashPos = max(strfind(dataFileName, '/'));
    dataFileName = dataFileName(slashPos+1 : end);
    user = getenv('USER');
    dataFileName = ['/tmp/',user,'/',dataFileName,'.mat'];
    tmpDir       = ['/tmp/',user,'/'];
    if ~exist(tmpDir,'dir')
        mkdir(tmpDir);
    end
    save(dataFileName,'sMat','equil')

    coilList     = get(sMat, 'coilList');
    numberOfCoil = length(coilList);
    cdir = pwd();
    disp(['fastParallelCalcSensitivityMatrix: cdir = ', cdir])
%     standAloneCmd = ['/home/lpang/work/zame/tools/fastSMatDEP/run_fastParallelCalcSensitivityColumn.sh ', ... %/scratch/graham/MLR2008a ';
%                     '/home/lpang/work/zame/tools/fastSMatDEP/v78/ '];
    standAloneCmd = ['/home/lpang/work/zame/fastSMat/run_fastParallelCalcSensitivityColumn.sh ', ... %/scratch/graham/MLR2008a ';
                    '/home/lpang/work/MATLAB_Compiler_Runtime/v78/ '];                
    for coilNum=1:numberOfCoil         
        cmd = ['nohup ',standAloneCmd, ' ', ...
               dataFileName, ' ', ...
               coilList{coilNum}, ' ', ...
               '> ',tmpDir,'output_',char(coilList{coilNum}),'.txt 2> ',tmpDir,'error_',char(coilList{coilNum}),'.txt & '];
           
%         cmd = ['nohup ',standAloneCmd, ' ', ...
%                dataFileName, ' ', ...
%                coilList{coilNum}, ' & ']
           
        system(cmd);    
        pause(5);
        disp(['After pause ',coilList{coilNum}])

    end
    
    while(1)
        d=dir([dataFileName,'_coil*']);
        pause(10);
        if (size(d,1) == numberOfCoil)
            break
        end
    end
    pause(10)
    ret = [];

    for ii=1:length(coilList)
        fileName = [dataFileName,'_coil_',char(coilList{ii}),'.mat'];
        if ~exist(fileName, 'file')
            error(['fileName ',fileName,' does not exist'])
        end
        s = load(fileName);
        ret = [ret, s.s];
    end
    delete([dataFileName,'*']);
    disp('DONE')

end