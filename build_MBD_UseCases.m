
% File: build_MBD_UseCases.m
% Description: Automatically creates a Simulink model 'MBD_UseCases.slx'
% with 20 subsystems, including annotations and logic placeholders.

modelName = 'MBD_UseCases';
new_system(modelName);
open_system(modelName);

% Define the names of subsystems
subsystems = {
    '01_BatteryCheckAndTurnOn'
    '02_DualSwitch_LEDControl'
    '03_DebounceLogic'
    '04_ToggleLED_RisingEdge'
    '05_PulseOnRelease'
    '06_TimeBasedReset'
    '07_FaultDetection'
    '08_PriorityInputControl'
    '09_CounterLogic'
    '10_SetResetLogic'
    '11_SpeedThresholdActivation'
    '12_BlinkerSimulation'
    '13_WindowControl'
    '14_HysteresisBehavior'
    '15_DualConditionTrigger'
    '16_StateBasedLEDPattern'
    '17_BrakeAndReverseCondition'
    '18_BatteryCutoffTimer'
    '19_ParkingSensorAlarm'
    '20_ModeSwitcher_Counter'
};

x = 30; y = 30; yOffset = 150;

for i = 1:length(subsystems)
    blockName = [modelName '/' subsystems{i}];
    add_block('built-in/Subsystem', blockName, ...
        'Position', [x y x+200 y+100]);
    % Add annotation
    add_block('built-in/Note', [blockName '_note'], ...
        'Position', [x+210 y x+510 y+50], ...
        'Text', ['Logic: ' subsystems{i}]);
    y = y + yOffset;
end

save_system(modelName);
disp(['Model ', modelName, '.slx created successfully.']);
