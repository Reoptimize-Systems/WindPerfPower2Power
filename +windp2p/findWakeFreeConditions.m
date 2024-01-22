function a = findWakeFreeConditions(Data, varargin)
% replace this h1 line
%
% Syntax
%
% a = findWakeFreeConditions (Data)
% a = findWakeFreeConditions (..., 'Parameter', Value)
%
% Description
%
% First step in "2. SMART BLADE's approach: the power-vs-power method" found in
% [1]
%
% [1] Quantifying the effect of vortex generator installation on wind power
%     production: An academia-industry case study
%     Authors: Hoon Hwangbo, Yu Ding, Oliver Eisele, Guido Weinzierl, Ulrich
%     Lang, Georgios Pechlivanoglou
%
% Input
%
%  Data - Nested structure containing the following fields:
%
%    ControlWTPre : Structure containing data from the control turbine in the
%      period prior to modification of control parameters on the test turbine.
%
%    ControlWTPost : Structure containing data from the control turbine in the
%      period after modification of control parameters on the test turbine.
%
%    TestWTPre : Structure containing data from test turbine in the period prior
%      to modification of control parameters on the test turbine.
%
%    TestWTPost : Structure containing data from the test turbine in the
%      period after modification of control parameters on the test turbine.
%
%    Each of these sub-structures must contain at least the following fields:
%
%    Time :
%
%    PowerActive :
%
% Addtional arguments may be supplied as parameter-value pairs. The available
% options are:
%
%  'MinimumPower' - scalar value, Watts. Data points with less than this value
%    of active power will be removed from the calculation. Default is 10 if not
%    supplied.
%
%  'WindDirectionBinSize' -
%
%
% Output
%
%  a -
%
%

%   Copyright 2023 Reoptimize Systems and Nordic Wind Technologies
%
%   Licensed under the Apache License, Version 2.0 (the "License");
%   you may not use this file except in compliance with the License.
%   You may obtain a copy of the License at
%
%       http://www.apache.org/licenses/LICENSE-2.0
%
%   Unless required by applicable law or agreed to in writing, software
%   distributed under the License is distributed on an "AS IS" BASIS,
%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%   See the License for the specific language governing permissions and
%   limitations under the License.

    % Default Parameters
    options.MinimumPower = 10;
    options.WindDirectionBinSize = 10;
    
    options = windp2p.parse_pv_pairs (options, varargin);
    
    %% Check Validity of optional parameters
    if ~(isreal(options.MinimumPower) && isscalar(options.MinimumPower))
      error('Expected MinimumPower to be a real numeric scalar');
    end
    
    if ~(isreal(options.WindDirectionBinSize) && isscalar(options.WindDirectionBinSize))
      error('Expected WindDirectionBinSize to be a real numeric scalar');
    end
    
    % Check Validity of Data structure members
    if ~isfield(Data,'ControlWTPre') ; error('Expected to find ControlWTPre in Data structure'); end
    if ~isfield(Data,'ControlWTPost') ; error('Expected to find ControlWTPost in Data structure'); end
    if ~isfield(Data,'TestWTPre') ; error('Expected to find TestWTPre in Data structure'); end
    if ~isfield(Data,'TestWTPost') ; error('Expected to find TestWTPost in Data structure'); end
    
    TimeExists = structfun(@(x) isfield(x,'Time'), Data);
    PowerActiveExists = structfun(@(x) isfield(x,'PowerActive'), Data);
    if ~all(TimeExists); error('Expected to find "Time" field'); end
    if ~all(PowerActiveExists); error('Expected to find "PowerActive" field'); end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%% Start of function %%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% Remove data where wind turbine is not on grid
    [TimePre, iPreCtrl, iPreMod] = intersect( Data.ControlWTPre.Time, ...
                                              Data.TestWTPre.Time, ...
                                              'stable' );
    
    [TimePost, iPostCtrl, iPostMod] = intersect( Data.ControlWTPost.Time, ...
                                                 Data.TestWTPost.Time, ...
                                                 'stable' );
    
    WindDirectionBins = linspace(0, 360, 720 / (options.WindDirectionBinSize * 2) + 1);
    
    % Bins = discretize(WindDirectionData, WindDirectionBins);


end
