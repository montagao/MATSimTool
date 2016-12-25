%@Author: Monta Gao
%@Updated: Nov. 28, 2016

function customSimPlot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% USER SETUP HERE %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Properties of the window
w_title = 'Template for Simulation Tool';
w_width = 800;
w_height = 800;

%properties of the main plot
p_title = 'Insert Title here';
y_label = 'Insert Y Label here';
x_label = 'Insert X Label here';
legendlabels = {'label1','label2'};

% figure path
% Image should be roughly 7:4 aspect ratio
% and should have appropriate (transparent) alpha channel
% e.g. 'rcStepResponse.png' if figure is placed in the same directory
fig_path = '700by300.png';

% define constants using an array of constant names
% and their respective values.
% we have to use char to pad the character vectors to equal lengths
% and then cellstr to to convert to a cell arra
c_names = cellstr(char('Constant1', 'Constant2'));
c_values = [1 50];

% define variables names and lower and upper limit
% e.g. v1 = ['Capacitance', 0, 100]
% in order to set the first slider as an x domain , (i.e. change domain of
% plot) set isXScale = true;
v_names = cellstr(char('X Slider','V1' ));
v_lims = [ 0.1 50; 1 50  ];
isXScale = true;

%define domain of the function to display
xs = linspace(0,15,151);
%set range of y values to display (comment to let it scale automatically)
y_lim = [ 0 1 ];

%USER DEFINE FUNCTION here
% save your functions and set it here
% if you want the function code to be output on the screen
% add them to user_fn_filenames
user_fns = {@voltagediveqn};


%Give brief description of the simulation 
info = cellstr(char('This tool can be used to show some neat things!'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NO NEED TO MODIFY ANY CODE BELOW%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%no need to modify this , just initializes v_values to the lower limit to
%match default slider appearance
v_values = zeros(1,length(v_lims));
for k = 1:1:size(v_lims,1)
    v_values(k) = v_lims(k,1);
end

%initialize plot object
f = figure('Visible' , 'off', 'Position', [500, 500, w_width, w_height]);
f.Name = w_title;

% to generate the figure along side with the plot we need to make two seperate subplots
diagramPlot = subplot('Position',[0.05, 0.67, 0.60, 0.3]);
emptyPlot =	subplot('Position',[0.9, 0.5,0.2,0.4]);% tiling trick to make matlab split this row
emptyPlot.Visible = 'off';

main = subplot('Position',[0.075, 0.1, 0.850, 0.3]);



%show image on diagramPlot
subplot(diagramPlot);
[im, map, alpha] = imread(fig_path);
circuitfigure = imshow(im, 'border', 'tight');
set(circuitfigure, 'AlphaData', alpha);
%set(circuitfigure);
% generate panel for other plot controls
opanel = uipanel('Title', 'plot', 'FontSize', 11,...
	'Position', [0.54, 0.45,0.1, 0.2]);

holdP_button = uicontrol('Parent', opanel, ...
    'Style', 'checkbox',...
    'Units', 'Normalized',...
    'String', 'Hold Plot',...
    'Position', [0.1 0.85 0.8 0.1]);

holdY_button = uicontrol('Parent', opanel, ...
    'Style', 'checkbox',...
    'Units', 'Normalized',...
    'String', 'Hold Y',...
    'Position', [0.1 0.65 0.8 0.1]);


%truesize;
subplot(main);

xlabel(x_label);
ylabel(y_label);
title(p_title);
if ( exist('y_lim','var'))
    ylim manual;
    c_plot = CustomPlot(p_title,xs, v_values,c_values, main, user_fns, y_lim, holdP_button, holdY_button);
else
    ylim auto;
    c_plot = CustomPlot(p_title,xs, v_values,c_values, main, user_fns, 0, holdP_button, holdY_button);
end
%plot initial data
c_plot.update_plot();
legend(legendlabels);


% generate constants UI panel and corresponding ui_elements
cpanel = uipanel('Title', 'constants', 'FontSize', 11,...
	'Position', [0.7, 0.6725,0.25, 0.3]);


c_n = length(c_names);
c_labels = zeros(1,c_n);
for k = 1 :1:c_n
	p_vector = [  0.1 0.88-(((k-1)/c_n)) 0.8 0.1];
	c_labels(k) = uicontrol( 'Parent', cpanel, ... 
	'Style', 'text',...
	'String', sprintf('%s : %0.2e',c_names{k},c_values(k)),...
    'Units', 'Normalized',...
    'FontSize', 10,...
	'HorizontalAlignment', 'center',...
	'Position', p_vector);
end


%generate info panel
ipanel = uipanel('Title', 'info', 'FontSize', 11,...
	'Position', [0.65, 0.45,0.32, 0.2]);

info_box = uicontrol('Parent', ipanel,...
	'Style', 'text',...
	'String', info ,...
    'Units', 'Normalized',...
    'Position', [0.1 0.05 0.8 0.9]);


% generate variable sliders UI panel;
vpanel = uipanel('Title', 'variables', 'FontSize', 11,...
	'Position', [0.05, 0.45,0.48, 0.2]);


v_n = length(v_names);
v_minlabels = zeros(1,v_n);
v_maxlabels = zeros(1,v_n);
v_labelsliders(v_n) = LabelSlider();

for k = 1 :1:v_n

	p_vector = [  0.15 0.82-(((k-1)/v_n)) 0.7 0.07];
	minp_vector = [  0.01 0.82-(((k-1)/v_n)) 0.12 0.08];
	maxp_vector = [  0.86 0.82-(((k-1)/v_n)) 0.12 0.08];
	valuep_vector = [  0.1 0.92-(((k-1)/v_n)) 0.3 0.09];
    
    if ( k == 1 && isXScale)
        isXScale = 1;
    else
        isXScale = 0;
    end
    v_labelsliders(k) = LabelSlider(k,vpanel,v_names{k}, valuep_vector, p_vector,v_lims(k,1),v_lims(k,2),c_plot, isXScale);
    
	v_minlabels(k) = uicontrol( 'Parent', vpanel, ...
	'Style',  'text',... 
	'String', sprintf('%0.2e',v_lims(k,1)),...
	'Units', 'Normalized',...
	'FontSize', 8,...
	'Position',minp_vector); 

	v_maxlabels(k) = uicontrol( 'Parent', vpanel, ...
	'Style',  'text',... 
	'String', sprintf('%0.2e',v_lims(k,2)),...
	'Units', 'Normalized',...
	'FontSize', 8,...
	'Position',maxp_vector); 
end

%generate equation panel;

%eqnpanel = uipanel('Title', 'function', 'FontSize', 11,...
%	'Position', [0.62, 0.1,0.35, 0.3]);

%n_fns = length(user_fn_filenames);
%function_labels = zeros(1,n_fns);
%for k = 1:1:n_fns
%    fn_string = fileread(user_fn_filenames{k});
%    fn_string
%    function_labels(k) = uicontrol('Parent',eqnpanel,...
%        'Style', 'text',...
%        'String', fn_string, ...
%        'Units', 'Normalized',...
%        'FontSize', 2,...
%        'Position', [0.1 1/n_fns-((k-1)/n_fns) 0.9 1/n_fns]);
%end

% Display figure after all configurations have finished.
movegui(f,'center');
f.Visible = 'on';
end