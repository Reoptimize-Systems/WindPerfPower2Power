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
    
    options = parse_pv_pairs (options, varargin);
    
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
    
    % Bins = discretize(WindDirectionData,WindDirectionBins);


end


function params = parse_pv_pairs(params,pv_pairs)
% parse_pv_pairs: parses sets of property value pairs, allows defaults
% usage: params=parse_pv_pairs(default_params,pv_pairs)
%
% arguments: (input)
%  default_params - structure, with one field for every potential
%             property/value pair. Each field will contain the default
%             value for that property. If no default is supplied for a
%             given property, then that field must be empty.
%
%  pv_array - cell array of property/value pairs.
%             Case is ignored when comparing properties to the list
%             of field names. Also, any unambiguous shortening of a
%             field/property name is allowed.
%
% arguments: (output)
%  params   - parameter struct that reflects any updated property/value
%             pairs in the pv_array.
%
% Example usage:
% First, set default values for the parameters. Assume we
% have four parameters that we wish to use optionally in
% the function examplefun.
%
%  - 'viscosity', which will have a default value of 1
%  - 'volume', which will default to 1
%  - 'pie' - which will have default value 3.141592653589793
%  - 'description' - a text field, left empty by default
%
% The first argument to examplefun is one which will always be
% supplied.
%
%   function examplefun(dummyarg1,varargin)
%   params.Viscosity = 1;
%   params.Volume = 1;
%   params.Pie = 3.141592653589793
%
%   params.Description = '';
%   params=parse_pv_pairs(params,varargin);
%   params
%
% Use examplefun, overriding the defaults for 'pie', 'viscosity'
% and 'description'. The 'volume' parameter is left at its default.
%
%   examplefun(rand(10),'vis',10,'pie',3,'Description','Hello world')
%
% params =
%     Viscosity: 10
%        Volume: 1
%           Pie: 3
%   Description: 'Hello world'
%
% Note that capitalization was ignored, and the property 'viscosity'
% was truncated as supplied. Also note that the order the pairs were
% supplied was arbitrary.

% LICENCE
%
% Copyright (c) 2009, John D'Errico
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
%
% * Redistributions of source code must retain the above copyright notice, this
%   list of conditions and the following disclaimer.
%
% * Redistributions in binary form must reproduce the above copyright notice,
%   this list of conditions and the following disclaimer in the documentation
%   and/or other materials provided with the distribution
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

    npv = length(pv_pairs);
    n = npv/2;

    if n~=floor(n)
      error 'Property/value pairs must come in PAIRS.'
    end
    if n<=0
      % just return the defaults
      return
    end

    if ~isstruct(params)
      error 'No structure for defaults was supplied'
    end

    % there was at least one pv pair. process any supplied
    propnames = fieldnames(params);
    lpropnames = lower(propnames);
    for i=1:n
      p_i = lower(pv_pairs{2*i-1});
      v_i = pv_pairs{2*i};

      result = strcmp(p_i,lpropnames);
      if ~any(result)
        % check for partial match
        ind = find(strncmp(p_i,lpropnames,length(p_i)));
        if isempty(ind)
          error(['No matching property found for: ',pv_pairs{2*i-1}])
        elseif length(ind)>1
          error(['Ambiguous property name: ',pv_pairs{2*i-1}])
        end
      else
        ind = find (result);
      end
      p_i = propnames{ind};

      % override the corresponding default in params
      params = setfield(params,p_i,v_i);

    end

end



