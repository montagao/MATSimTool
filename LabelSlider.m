classdef LabelSlider < handle
	properties
        name
	   label
	   slider
	   id
       c_plot
       isXScale
       isLog
	end

	methods
	   function obj =LabelSlider(id, vpanel,name, label_vector, slider_vector,default,max,c_plot ,isXScale)
          if (nargin == 0)  
          else
            obj.id = id;
            obj.name = name;
            obj.isXScale = isXScale;
            magnitude_diff = max/default;
            if ( default ~= 0)
                obj.isLog = log10(magnitude_diff) >= 3;
            else
                obj.isLog = false;
            end
            obj.c_plot = c_plot;
            
            
            if (obj.isLog)
                % set log slider if magnitude difference is more than 3
                % orders of magnitude.
                obj.slider = uicontrol( 'Parent', vpanel, ... 
                'Style', 'slider',...
                'Units', 'Normalized',...
                'Max',log10(max) ,...
                'Min',log10(default) ,...
                'Value', log10(default), ...
                'FontSize', 8,...
                'Callback', @obj.sliderCallback,...
                'Position', slider_vector,...
                'SliderStep', [0.01 0.10]);
            else
                obj.slider = uicontrol( 'Parent', vpanel, ... 
                'Style', 'slider',...
                'Units', 'Normalized',...
                'Max',max ,...
                'Min',default ,...
                'Value', default, ...
                'FontSize', 8,...
                'Callback', @obj.sliderCallback,...
                'Position', slider_vector,...
                'SliderStep', [0.01 0.10]);
            end

            obj.label = uicontrol( 'Parent', vpanel, ... 
            'Style', 'text',...
            'String', sprintf('%s:	%0.2f',name,default),...
            'Units', 'Normalized',...
            'FontSize', 8,...
            'HorizontalAlignment', 'left',...
            'Position', label_vector);

          end
       end
       
	   function sliderCallback(obj,source,~)
          %if specified this slider to control time plot, change c_plot xs
          %accordingly. Value of the slider corresponds to max x value
          %displayed.
          val = 0;
          if (obj.isLog)
              set(source,'UserData',10^get(source,'Value'));
              val = get(source, 'UserData');
          else 
              val = get(source, 'Value');
          end
          
          %format value to nearest .05
          [coefficient,exponent] = textscan(strrep(sprintf('%E',val),'E','#'),'%f#%f');
          coefficient = cell2mat(coefficient);
          val = val*((round(coefficient/0.05)*0.05)/coefficient);
          
          if (obj.isLog)
              if (log10(val) < get(source, 'Min'))
                  set(source, 'Value', get(source, 'Min'));
              else
                  set(source, 'Value', log10(val));
              end
          else 
              if (val < get(source, 'Min'))
                set(source, 'Value', get(source, 'Min'));
              else
                set(source, 'Value', val);
              end
          end
            
          if (obj.isXScale)
              if (obj.isLog)
                 min = 10^get(source, 'Min');
              else
                 min = get(source, 'Min');
              end
              obj.c_plot.xs = linspace( min, val, 1000+1);
          end
          obj.c_plot.v_values(obj.id) = val;
		  obj.label.String = sprintf('%s:	%0.2e',obj.name,val);
          obj.c_plot.update_plot();
       end
       
	end
end