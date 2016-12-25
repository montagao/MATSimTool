classdef CustomPlot < handle
	properties
		% title : title of the plot
		% v_values : array where variable values are stored
		% plot : subplot object.
		my_title;
		v_values
        c_values
		my_plot
        xs;
        y_lim;
        
        %handle to hold plot uicontrol
        % check it's value to determine whether or not to hold the previous
        % plot.
        holdplotb;
        holdy;
        
		%usereqn is a function of the form y = function ( x) 
		% and defines the output vector y in terms of the input vector x.
		% this needs to be called everytime we update the plot (i.e. when a variable is changed)
		user_fns
	end

	methods
		function obj = CustomPlot(title,xs,v_values,c_values,myplot,user_fns,y_lim, holdplotb,holdY_button )
			obj.my_title = title;
            obj.holdplotb = holdplotb;
            obj.holdy = holdY_button;
            obj.y_lim = y_lim;
			obj.v_values = v_values;
            obj.c_values = c_values;
			obj.user_fns = user_fns;
			obj.my_plot = myplot;
            obj.xs = xs;
		end

		function update_plot(obj)
            % get handle to current axes
            ax = gca;
            if (get(obj.holdplotb, 'Value') ~= true)
                cla;
            else
                %fade color on previous lines
                h = findobj(gca,'Type','line');
                for i = 1:length(h)
                    currentLine = h(i);
                    currentLine.Color(4) = 0.4;
                end
                ax.ColorOrderIndex = 1;
            end
            hold on;
            
            obj.v_values;
			subplot(obj.my_plot);
            xlim([obj.xs(1), obj.xs(end)]);
            
			for k = 1:1:length(obj.user_fns)
                length(obj.user_fns);
                current_fn = obj.user_fns{k};
				y = current_fn(obj.xs, obj.v_values, obj.c_values);
				plot(obj.xs, y);
                
            end
            

			title(obj.my_title);
            if (size(obj.y_lim,2) == 2)
                ylim(obj.y_lim);
            else

                if ( get(obj.holdy, 'Value') == true)
                    ylim manual;
                else
                    ylim auto;
                end
            end
            if (get(obj.holdplotb, 'Value') ~= true)
                hold off;
            else
                hold on;
            end
            

        end
	end
end