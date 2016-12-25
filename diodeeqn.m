function v = diodeeqn( x, v_values, c_values)
    %use id to determine Vd iteratively.
    Vt = c_values(3);
    Vs = c_values(1);
    
    id_old = 1e-3;
    id = -1;
    Vd = 0.7;
    Rs = c_values(2);
    Rl = x;
    
    %calculate thevenin resistance 
    Rth = ((Rs*Rl) ./ (Rs+Rl));
    
    %calculate thevenin voltage
    Vth = Vs*(Rl./(Rs+Rl));
    
    %calculate Vd and diode current.
    while (abs(abs(id)-abs(id_old)) > 1e-5)
        id_old = id;
        id = (Vth - Vd)./Rth;
        Vd = 0.7 + Vt.*log(id/1e-3);
    end
    
    v = Vd*3;
end