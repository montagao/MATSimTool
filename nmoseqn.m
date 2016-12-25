function Id = nmoseqn(x, v_values, c_values)
    W = c_values(1);
    L = c_values(2);
    Cox = c_values(3);
    u_n = c_values(4);
    k_n = Cox * u_n; 
    Vt = v_values(3);
    Vgs = v_values(2);
    Vds = x;
    V_ov = Vgs - Vt;
    % Determine if diode is in cutoff,  triode, or saturated region
    Id = zeros(1,size(x,2));
    for k=1:1:size(x,2) 
        if ( Vgs < Vt )
            Id(k) = 0;
        elseif ( Vds(k) >= V_ov )
            Id(k) = 0.5*k_n*(W/L)*V_ov.^2;
        else
            Id(k) = k_n*(W/L)*((V_ov)*Vds(k)-0.5*Vds(k).^2);
        end
    end
	return 
end
