function data = nacellePositionNorthing (data, test_turbine_angle_relative_2_ref_turbine)
% replae h1 line
%
% Syntax
%
% 
% 
% Input
%
%  data - Nested structure containing the following fields:
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
%    DirectionNacelle :
%
%  test_turbine_angle_relative_2_ref_turbine - 
%
% Output
%
%
%  data - 
%
$


    % the nacell zero position of each turbine may not be aligned to
    % geographic north or "True North", in this function we adjust the
    % nacelle position of the test turbine to be aligned with the reference
    % turbine by identifying peaks in the relative power of the test and
    % reference turbine due to wake interaction

    data.PowerActiveControlWTPreVTestWTPre = data.ControlWTPre.PowerActive ./ data.TestWTPre.PowerActive;

    data.VelocityWindWTPreVPowerTestWTPre = data.ControlWTPre.VelocityWind ./ data.TestWTPre.VelocityWind;

    % From maps of the site we can identify the angle at which we would
    % expect to see the peaks in the data, and compare to the angle where
    % the peaks appear in the data. we can then adjust the Nacell direction
    % of both the test and reference turbine to correct relative to true
    % north



end