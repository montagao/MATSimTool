function Il = rlceqn(x, v_values, c_values)
    C = v_values(2);
    R = v_values(3);
    L = v_values(4);
    Is = c_values(1);
    
    alpha = 1/(2*R*C)
    w0 = 1/sqrt(L*C)
    wd = sqrt(w0^2 - alpha^2);
    Il = zeros(2,size(x,2));
    %Determine if we have underdamped, critically damped, or overdamped
    %case.
   
    if ( alpha^2 < w0^2 ) % case is underdamped 
        'underdamped'       
       Il = f1(x);
       % plot v ( which is L*di*dt)
       Il(2,:) = Dc(@f1,x, 1e-5);
         
    elseif ( abs(alpha - w0) < 0.0005 ) % case is critically damped
        'critically damped'
       Il = f2(x);
       % plot v ( which is L*di*dt)
       Il(2,:) = Dc(@f2,x, 1e-5);
         
    else                    %  Case is overdamped
        'overdamped'
       Il = f3(x);
       % plot v ( which is L*di*dt)
       Il(2,:) = Dc(@f3,x,1e-5);
         
    end
    
    function Il = f1(x)
       A1 = -Is;
       A2 = Is/wd;          
       Il = Is + exp(-alpha.*x).*(A1*cos(wd.*x)+A2.*sin(wd.*x));
    end
        
    function Il = f2(x)
       A1 = -Is;
       A2 = -alpha*Is;
       Il = Is + (A1 + A2.*x).*exp(-alpha.*x);
    end

    function Il = f3(x)
       s1 = -alpha + sqrt(alpha^2-w0^2);
       s2 = -alpha - sqrt(alpha^2-w0^2);
       A2 = -Is/(1-(s2/s1));
       A1 = -A2*(s2/s1);
       Il = Is + A1*exp(s1*x)+A2*exp(s2*x);
    end

    function dy = Dc( f, x, h )
        % centred difference derivative
        dy = (f(x+h)-f(x-h))./(2*h);
        return;
    end

	return 
end
