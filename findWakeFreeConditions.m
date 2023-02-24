function a = findWakeFreeConditions(Data, varargin)

%%First step in "2. SMART BLADE�s approach: the power-vs-power method" found in 
%[1] Quantifying the effect of vortex generator installation on wind power production: An
%     academia-industry case study 
%     Authors: Hoon Hwangbo, Yu Ding, Oliver Eisele, Guido Weinzierl, Ulrich Lang, Georgios Pechlivanoglou
%
%[a] = findWakeFreeConditions(Data)
%[a] = findWakeFreeConditions(Data, 'parameter1', value1, ...)
%
%a is the output
%
%'MinimumPower' | (Numeric) [kW] | dflt = 10 | Remove data points with less than this amount of active power

if nargin<1
   error('Expected atleast one input') 
end

%% Check Validity of Data
if ~isfield(Data,'PreCtrlWT') ; error('Expected to find PreCtrlWT in Data structure'); end
if ~isfield(Data,'PostCtrlWT') ; error('Expected to find PostCtrlWT in Data structure'); end
if ~isfield(Data,'PreModWT') ; error('Expected to find PreModWT in Data structure'); end
if ~isfield(Data,'PostModWT') ; error('Expected to find PostModWT in Data structure'); end

%% Default Parameters
MinimumPower = 10;

%% User-Specificed Parameters
for i = 1:2:numel(varargin)
   switch lower(varargin{i})
       case 'minimumpower'
           MinimumPower = varargin{i+1};
       otherwise
           warning([varargin{i} 'is not a valid property for findWakeFreeConditions function'])
   end
end

%% Check Validity of Parameters
if ~isnumeric(MinimumPower); error('Expected MinimumPower to be numeric'); end

%%%%%%%%%%%%%%%%%%%%%%%%% Start of function %%%%%%%%%%%%%%%%%%%%%%%%%

%% Remove data where wind turbine is not on grid
[TimeCtrl, iPreCtrl, iPreMod] = union(Data.PreCtrlWT.Time,Data.PreModWT.Time,'stable');

a = 1;





end