function curve=getDivFluxCurve(tempEq, xeq, dr)
 %% curve=getDivFluxCurve(tempEq, xeq, dr)
    curve = [0; 0];
    psi = get(tempEq,'psi');
    % params = parameters(tempEq);
    % psiTarget = interp2(psi, params.rout+dr, 0.0);
    
    %Accurately determine the LCFS (assume X point) and hence target flux
    %surface
    [psi_boundary, zx, rx]=findxpoint2(psi);
    [dummy, n]=min(abs(psi_boundary - get(tempEq, 'psi_boundary')));
    [r_sect, psi_sect]=section(psi);
    Ra=oxing(r_sect, psi_sect-psi_boundary(n));  
    if length(Ra) <= 1
        return
    end
    psiTarget=interp1(r_sect, psi_sect, max(Ra)+dr);    

    if (isnan(psiTarget))
        return
    end
    curve = contourc(psi, [1,1]*psiTarget);
    curve = curve';
    contourDistances   = [curve(:,1)-(max(Ra)+dr), curve(:,2)];
    [dummy, targetPos] = min(contourDistances(:,1).^2+contourDistances(:,2).^2);
    while (~isempty(curve))
       howmany = fix(curve(1,2));
       if (targetPos > howmany)
           targetPos = targetPos - howmany + 1;
           curve = curve(2+howmany:end, :); 
       else
           curve = curve(2:2+howmany-1, :); 
           break
       end
    end
    if (isempty(curve))
        return
    end
    curve = curve(find(curve(:,2) <= 0.0),:);
    curve = curve';
    
%     pin = curve(:,end);
    dg=plotmastuoutline;
    rDivChamber =  dg.r(7:16);
    zDivChamber = -dg.z(7:16);
    divIdx = convhull(rDivChamber,zDivChamber);
%     pmi = (pin+pfi)/2;
    in  = inpolygon(curve(1,:),curve(2,:),rDivChamber,zDivChamber);
    if (all(in == 0))
        pin = [curve(1,end); curve(2,end)];
    else
        pin = [curve(1,in); curve(2,in)];
        pin = pin(:,1);
    end
    psi = get(xeq, 'psi');
    clear curve;
    curve = contourc(psi, [1,1]*psiTarget);
    curve = curve';
    contourDistances   = [curve(:,1)-pin(1), curve(:,2)-pin(2)];
    [dummy, targetPos] = min(contourDistances(:,1).^2+contourDistances(:,2).^2);
    while (~isempty(curve))
       howmany = fix(curve(1,2));
       if (targetPos > howmany)
           targetPos = targetPos - howmany + 1;
           curve = curve(2+howmany:end, :); 
       else
           curve = curve(2:2+howmany-1, :); 
           break
       end
    end
    if (isempty(curve))
        return
    end
    curve = curve(find(curve(:,2) <= 0.0),:);
    curve = curve';
    
end