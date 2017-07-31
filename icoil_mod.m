function [icoil_total, x_control_vc, y_control_vc, ...
    equil_new]=icoil_mod(tol, icoil_total, x_control_vc, ...
    x_control, y_control_vc, y_control, iso, dr, dz, equil_new, ...
    coilset, smatrix, config, control, control_p, displ)
% Function to calculate a better displacement for a given control parameter
% Makes also adjustment of the other control parameters by a given smatrix,
% this can be used to create new smatrices 
dz=y_control_vc-y_control;  % Gets displacement of control parametrers
dr=x_control_vc-x_control;
%-------------------------------------------------------------------------%
% Cycle to achieve a better displacement:
if control_p==1 || control_p==2 || control_p==3
    while abs(dr(control_p))~=(displ/100)
        d_r=x_control_vc(control_p)-x_control(control_p)  % Get the displacement of control point
        if (abs(d_r)<((abs(displ)/100)+(tol/10)) && abs(d_r)>((abs(displ)/100)-(tol/10)))
            % If the calculated displacement (abs val) is within a half of the
            % tolerance, finish the cycle
            d_r  % Print the final displacement achieved
            break
        end
        if d_r<(displ/100)  % ADJUSTABLE ACCORDING TO THE DIRECTION OF MOVT.
            [icoil_total]=v_circ(equil_new, coilset, smatrix, (abs(d_r)*displ), control_p);
        elseif d_r>(displ/100)
            [icoil_total]=v_circ(equil_new, coilset, smatrix, (-abs(d_r)*displ), control_p);
        end
        % Calculate new eq:
        feedback=fiesta_feedback2(get(config,'grid'), coilset,'p6', iso);
        equil_new=set(equil_new,config,'feedback',feedback,'control',control);
        equil_new=set(equil_new,config,'icoil',icoil_total);
        [x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
        
    end
elseif control_p==4 || control_p==5 || control_p==6
    %displ=-20;
    while dz(control_p)~=(displ/100)
        %d_z=y_control_vc(control_p)-y_control(control_p)  % Get the displacement of control point
        d_z=y_control(control_p)-y_control_vc(control_p)
        if (d_z>((displ/100)-(tol/2)) && d_z<((displ/100)+(tol/2)))
            % If the calculated displacement (abs val) is within a half of the
            % tolerance, finish the cycle
            d_z  % Print the final displacement achieved
            break
        end
        if d_z>(displ/100)  % ADJUSTABLE ACCORDING TO THE DIRECTION OF MOVT.
            [icoil_total]=v_circ(equil_new, coilset, smatrix, (-d_z*10/displ), control_p);
        elseif d_z<(displ/100)
            [icoil_total]=v_circ(equil_new, coilset, smatrix, (d_z*10/displ), control_p);
        end
        % Calculate new eq:
        feedback=fiesta_feedback2(get(config,'grid'), coilset,'p6', iso);
        equil_new=set(equil_new,config,'feedback',feedback,'control',control);
        equil_new=set(equil_new,config,'icoil',icoil_total);
        [x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
        %plot(equil_new, 'psi_boundary', 'g')
    end
end
%-------------------------------------------------------------------------%
% Cycle to adjust the position of other control parameters
count=0;  % Count # of iterations
dz=y_control_vc-y_control;
dr=x_control_vc-x_control;
% Exclude the last two control points (same as prev 2) and
% raise a flag if a control parameter goes above tolerance
dr_flag=abs(dr(1:6))>tol;
dz_flag=abs(dz(1:6))>tol;

while (any(abs(dz)>tol) && (any(abs(dr)>tol) || dz_flag(control_p)==1))
    if (dr_flag(1)==1 && control_p~=1)
        while abs(x_control_vc(1)-x_control(1))>tol
            dr_in=x_control_vc(1)-x_control(1)
            if dr_in>0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, -abs(dr_in)*10, 1);
            elseif dr_in<0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, abs(dr_in)*10, 1);
            end
            feedback=fiesta_feedback2(get(config,'grid'), coilset,'p6', iso);
            equil_new=set(equil_new,config,'feedback',feedback,'control',control);
            equil_new=set(equil_new,config,'icoil',icoil_total);
            [x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
            dz=y_control_vc-y_control;
            dr=x_control_vc-x_control;
            dr_flag=abs(dr(1:6))>tol;
            dz_flag=abs(dz(1:6))>tol;
        end
    elseif (dr_flag(2)==1 && control_p~=2)
        while abs(x_control_vc(2)-x_control(2))>tol
            dr_out=x_control_vc(2)-x_control(2)
            if dr_out<0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, abs(dr_out)*100, 2);
            elseif dr_out>0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, -abs(dr_out)*100, 2);
            end
            feedback=fiesta_feedback2(get(config,'grid'), coilset,'p6', iso);
            equil_new=set(equil_new,config,'feedback',feedback,'control',control);
            equil_new=set(equil_new,config,'icoil',icoil_total);
            [x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
            dz=y_control_vc-y_control;
            dr=x_control_vc-x_control;
            dr_flag=abs(dr(1:6))>tol;
            dz_flag=abs(dz(1:6))>tol;
        end
    elseif (dr_flag(3)==1 && control_p~=3)
        while abs(x_control_vc(3)-x_control(3))>tol
            dr_xp=x_control_vc(3)-x_control(3)
            if dr_xp<0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, abs(dr_xp)*100, 3);
            elseif dr_xp>0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, -abs(dr_xp)*100, 3);
            end
            feedback=fiesta_feedback2(get(config,'grid'), coilset,'p6', iso);
            equil_new=set(equil_new,config,'feedback',feedback,'control',control);
            equil_new=set(equil_new,config,'icoil',icoil_total);
            [x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
            dz=y_control_vc-y_control;
            dr=x_control_vc-x_control;
            dr_flag=abs(dr(1:6))>tol;
            dz_flag=abs(dz(1:6))>tol;
        end
    elseif (dz_flag(4)==1 && control_p~=4)
        while abs(y_control_vc(3)-y_control(3))>tol
            dz_xp=y_control_vc(3)-y_control(3)
            if dz_xp>0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, -abs(dz_xp), 4);
            elseif dz_xp<0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, abs(dz_xp), 4);
            end
            feedback=fiesta_feedback2(get(config,'grid'), coilset,'p6', iso);
            equil_new=set(equil_new,config,'feedback',feedback,'control',control);
            equil_new=set(equil_new,config,'icoil',icoil_total);
            [x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
            dz=y_control_vc-y_control;
            dr=x_control_vc-x_control;
            dr_flag=abs(dr(1:6))>tol;
            dz_flag=abs(dz(1:6))>tol;
        end
    elseif (dz_flag(5)==1 && control_p~=5)
        while abs(y_control_vc(5)-y_control(5))>tol
            dz_isp=y_control_vc(5)-y_control(5)
            if dz_isp>0
                [icoil_total]=v_circ(equil_new, coilset, smatrix,-abs(dz_isp)*100, 5);
            elseif dz_isp<0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, abs(dz_isp)*100, 5);
            end
            feedback=fiesta_feedback2(get(config,'grid'), coilset,'p6', iso);
            equil_new=set(equil_new,config,'feedback',feedback,'control',control);
            equil_new=set(equil_new,config,'icoil',icoil_total);
            [x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
            dz=y_control_vc-y_control;
            dr=x_control_vc-x_control;
            dr_flag=abs(dr(1:6))>tol;
            dz_flag=abs(dz(1:6))>tol;
        end
    elseif (dz_flag(6)==1 && control_p~=6)
        while abs(y_control_vc(6)-y_control(6))>tol
            dz_osp=y_control_vc(6)-y_control(6)
            if dz_osp<0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, -abs(dz_osp)*100, 6);
            elseif dz_osp>0
                [icoil_total]=v_circ(equil_new, coilset, smatrix, abs(dz_osp)*100, 6);
            end
            feedback=fiesta_feedback2(get(config,'grid'), coilset,'p6', iso);
            equil_new=set(equil_new,config,'feedback',feedback,'control',control);
            equil_new=set(equil_new,config,'icoil',icoil_total);
            [x_control_vc, y_control_vc, conn_len_vc]=control_pointsV3(equil_new);
            dz=y_control_vc-y_control;
            dr=x_control_vc-x_control;
            dr_flag=abs(dr(1:6))>tol;
            dz_flag=abs(dz(1:6))>tol;
        end
    end
    count=count+1;
    if count==80
        return
    end
end