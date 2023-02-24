function a = findWakeFreeConditions(Data, varargin)

%%First step in "2. SMART BLADE’s approach: the power-vs-power method" found in 
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

TimeExists = structfun(@(x) isfield(x,'Time'), Data); 
ActivePowerExists = structfun(@(x) isfield(x,'ActivePower'), Data); 
if ~all(TimeExists); error('Expected to find "Time" field'); end
if ~all(ActivePowerExists); error('Expected to find "ActivePower" field'); end

%% Default Parameters
MinimumPower = 10;
WindDirectionBinSize = 10;

%% User-Specificed Parameters
for i = 1:2:numel(varargin)
   switch lower(varargin{i})
       case 'minimumpower'
           MinimumPower = varargin{i+1};
       case 'winddirectionbininterval'
           WindDirectionBinSize = varargin{i+1};
       otherwise
           warning([varargin{i} 'is not a valid property for findWakeFreeConditions function'])
   end
end

%% Check Validity of Parameters
if ~isnumeric(MinimumPower); error('Expected MinimumPower to be numeric'); end
if ~isnumeric(WindDirectionBinSize); error('Expected WindDirectionBinInterval to be numeric'); end

%%%%%%%%%%%%%%%%%%%%%%%%% Start of function %%%%%%%%%%%%%%%%%%%%%%%%%

%% Remove data where wind turbine is not on grid
[TimePre, iPreCtrl, iPreMod] = intersect(Data.PreCtrlWT.Time,Data.PreModWT.Time,'stable');
[TimePost, iPostCtrl, iPostMod] = intersect(Data.PostCtrlWT.Time,Data.PostModWT.Time,'stable');

WindDirectionBins = linspace(0,360,720/(WindDirectionBinSize*2)+1);

% Bins = discretize(WindDirectionData,WindDirectionBins);








end