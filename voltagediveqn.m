function y = voltagediveqn(x, v_values, c_values)
	Vin = c_values(1);
    Vo = Vin*((x)./(1+(x)));
    V1 = Vin*((1./(x))./(1+1./(x)));
    y = zeros(3,size(x,2));
    y(1,:) = Vo(1,:);
    y(2,:) = V1;
    y(3,:) = Vin;
	return
end