function nmosSim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% USER SETUP HERE %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Properties of the window
w_title = 'MOSFET (NMOS) Current-Voltage Characteristics';
w_width = 800;
w_height = 800;

%properties of the main plot
p_title = 'MOSFET Regions of Operation';
y_label = 'Ids';
x_label = 'Vds';
legendlabels = {'Ids'};

% figure path
% Image should be roughly 7:4 aspect ratio
% and should have appropriate (transparent) alpha channel
% e.g. 'rcStepResponse.png' if figure is placed in the same directory
fig_path = 'nmos.png';

% define constants using an array of constant names
% and their respective values.
% we have to use char to pad the character vectors to equal lengths
% and then cellstr to to convert to a cell arra
c_names = cellstr(char('W [m]', 'L [m]', 'Cox [F/um^2]','u_n [m^2/V*s]'));
c_values = [2e-6, 0.18e-6, 8.6e-1,4.5 ];

% define variables names and lower and upper limit
% e.g. v1 = ['Capacitance', 0, 100]
v_names = cellstr(char('Vds Range', 'Vgs' , 'Vt'));
v_lims = [0 3; 0 1; 0 1];
isXScale = 1;

%define domain of the function to display
xs = linspace(0,1,101);
%set range of y values to display (comment to let it scale automatically)
%y_lim = [ 0 10 ];

%USER DEFINE FUNCTION here
% save your functions and set it here
% if you want the function code to be output on the screen
% add them to user_fn_filenames
user_fns = {@nmoseqn};

%functions in which the code is to be displayed
user_fn_filenames = cellstr(char('nmoseqn.m'));

%Give brief description of the simulation 
info = cellstr(char('This interactive tool demonstrates the basic different types of n-channels formed due to Vgs and Vds.',...
    'Recall: MOSFET is in cutoff when Vgs < Vt, Triode when Vds < Vov and Saturated when Vds >= Vov',...
    'Also note how the curve appears linear when Vds is small' ));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NO NEED TO MODIFY ANY CODE BELOW%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%no need to modify this , just initializes v_values to the lower limit to
%match default slider appearance
v_values = zeros(1,length(v_lims));
for k = 1:1:length(v_lims)
    length(v_lims);
    v_values(k) = v_lims(k,1);
end

%initialize plot object
f = figure('Visible' , 'off', 'Position', [500, 500, w_width, w_height]);
f.Name = w_title;

% to generate the figure along side with the plot we need to make two seperate subplots
diagramPlot = subplot('Position',[0.05, 0.62, 0.7, 0.4]);
emptyPlot =	subplot('Position',[0.9, 0.5,0.2,0.4]);% tiling trick to make matlab split this row
emptyPlot.Visible = 'off';

main = subplot('Position',[0.075, 0.1, 0.85, 0.3]);

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


%show image on diagramPlot
subplot(diagramPlot);
[im, map, alpha] = imread(fig_path);
circuitfigure = imshow(im, 'border', 'tight');
set(circuitfigure, 'AlphaData', alpha);

%set(circuitfigure);

%truesize;
subplot(main);

xlabel(x_label);
ylabel(y_label);
title(p_title);
if ( exist('y_lim','var'))
    ylim manual;
    'yes'
    c_plot = CustomPlot(p_title,xs, v_values,c_values, main, user_fns, y_lim, holdP_button, holdY_button);
else
    ylim auto;
    c_plot = CustomPlot(p_title,xs, v_values,c_values, main, user_fns, 0, holdP_button, holdY_button);
end
%plot initial data
c_plot.update_plot();


% generate constants UI panel and corresponding ui_elements
cpanel = uipanel('Title', 'constants', 'FontSize', 11,...
	'Position', [0.68, 0.6725,0.3, 0.3]);


c_n = length(c_names);
c_labels = zeros(1,c_n);
for k = 1 :1:c_n
	p_vector = [  0.1 0.88-(((k-1)/c_n)) 0.8 0.1];
	c_labels(k) = uicontrol( 'Parent', cpanel, ... 
	'Style', 'text',...
	'String', sprintf('%s : %0.4e',c_names{k},c_values(k)),...
    'Units', 'Normalized',...
    'FontSize', 11,...
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

	p_vector = [  0.1 0.82-(((k-1)/v_n)) 0.8 0.07];
	minp_vector = [  0.01 0.82-(((k-1)/v_n)) 0.07 0.08];
	maxp_vector = [  0.91 0.82-(((k-1)/v_n)) 0.07 0.08];
	valuep_vector = [  0.1 0.92-(((k-1)/v_n)) 0.3 0.09];
    
    if ( k == 1 && isXScale)
        isXScale = 1;
    else
        isXScale = 0;
    end
    
    v_labelsliders(k) = LabelSlider(k,vpanel,v_names{k}, valuep_vector, p_vector,v_lims(k,1),v_lims(k,2),c_plot, isXScale);

    
	v_minlabels(k) = uicontrol( 'Parent', vpanel, ...
	'Style',  'text',... 
	'String', sprintf('%0.4f',v_lims(k,1)),...
	'Units', 'Normalized',...
	'FontSize', 8,...
	'Position',minp_vector); 

	v_maxlabels(k) = uicontrol( 'Parent', vpanel, ...
	'Style',  'text',... 
	'String', sprintf('%0.2f',v_lims(k,2)),...
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