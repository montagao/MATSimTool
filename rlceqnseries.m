function V = rlceqn(x, v_values, c_values)
    C = v_values(2);
    R = v_values(3);
    L = v_values(4);
    Vs = c_values(1);
    
    alpha = R/(2*L)
    w0 = 1/sqrt(L*C)
    wd = sqrt(w0^2 - alpha^2);
    V = zeros(2,size(x,2));
    %Determine if we have underdamped, critically damped, or overdamped
    %case.
   
    if ( alpha^2 < w0^2 ) % case is underdamped 
        'underdamped'       
       V(1,:) = f1(x);
       % plot v ( which is L*di*dt)
       V(2,:) = C*Dc(@f1,x, 1e-5);
         
    elseif ( abs(alpha - w0) < 0.0005 ) % case is critically damped
        'critically damped'
       V(1,:) = f2(x);
       % plot v ( which is L*di*dt)
       V(2,:) = C*Dc(@f2,x, 1e-5);
         
    else                    %  Case is overdamped
        'overdamped'
       V(1,:) = f3(x);
       % plot v ( which is L*di*dt)
       V(2,:) = C*Dc(@f3,x,1e-5);
         
    end
    
    function V = f1(x)
       A1 = -Vs;
       A2 = Vs/wd;          
       V = Vs + exp(-alpha.*x).*(A1*cos(wd.*x)+A2.*sin(wd.*x));
    end
        
    function V = f2(x)
       A1 = -Vs;
       A2 = -alpha*Vs;
       V = Vs + (A1 + A2.*x).*exp(-alpha.*x);
    end

    function V = f3(x)
       s1 = -alpha + sqrt(alpha^2-w0^2);
       s2 = -alpha - sqrt(alpha^2-w0^2);
       A2 = -Vs/(1-(s2/s1));
       A1 = -A2*(s2/s1);
       V = Vs + A1*exp(s1*x)+A2*exp(s2*x);
    end

    function dy = Dc( f, x, h )
        % centred difference derivative
        dy = (f(x+h)-f(x-h))./(2*h);
        return;
    end

	return 
end
