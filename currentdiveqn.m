function y = currentdiveqn(x, v_values, c_values)
	i = c_values(1);

    
    i2 = i*((x.^-1)./(1+(x.^-1)));
    y = zeros(3,size(x,2));
    y(1,:) = i;
    y(2,:) = i2(1,:);
    y(3,:) = i-i2;
	return
end