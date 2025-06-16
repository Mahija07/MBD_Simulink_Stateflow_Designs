% File: build_MBD_UseCases_FullLogic.m

modelName = 'MBD_UseCasesL';
new_system(modelName);
open_system(modelName);

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
    blockPath = [modelName '/' subsystems{i}];
    add_block('simulink/Ports & Subsystems/Subsystem', blockPath, ...
        'Position', [x y x+250 y+100]);
    open_system(blockPath);

    % Delete default I/O blocks
    try
        delete_line(blockPath, 'In1/1', 'Out1/1');
    catch; end
    try
        delete_block([blockPath '/In1']);
        delete_block([blockPath '/Out1']);
    catch; end

    % Add new input and output ports
    add_block('simulink/Sources/In1', [blockPath '/In1'], 'Position', [30 40 60 60]);
    add_block('simulink/Sources/In1', [blockPath '/In2'], 'Position', [30 100 60 120]);
    add_block('simulink/Sinks/Out1', [blockPath '/Out1'], 'Position', [400 70 430 90]);

    switch subsystems{i}
        case '01_BatteryCheckAndTurnOn'
            add_block('simulink/Discrete/Delay', [blockPath '/Delay'], ...
                'DelayLength', '5', 'Position', [90 40 130 60]);
            add_block('simulink/Logic and Bit Operations/Compare To Constant', ...
                [blockPath '/Compare'], 'const', '100', ...
                'relop', '<', 'Position', [170 40 220 60]);
            add_block('simulink/Signal Routing/Switch', [blockPath '/Switch'], ...
                'Threshold', '0.5', 'Position', [260 40 300 70]);
            add_block('simulink/Sources/Constant', ...
                [blockPath '/LED_ON'], 'Value', '1', 'Position', [140 100 170 120]);
            add_line(blockPath, 'In1/1', 'Delay/1');
            add_line(blockPath, 'Delay/1', 'Compare/1');
            add_line(blockPath, 'Compare/1', 'Switch/2');
            add_line(blockPath, 'LED_ON/1', 'Switch/1');
            add_line(blockPath, 'In1/1', 'Switch/3');
            add_line(blockPath, 'Switch/1', 'Out1/1');

        case '02_DualSwitch_LEDControl'
            add_block('simulink/Logic and Bit Operations/Logical Operator', ...
                [blockPath '/OR'], 'Operator', 'OR', 'Position', [160 50 190 80]);
            add_block('simulink/Sources/Constant', ...
                [blockPath '/LED'], 'Value', '1', 'Position', [200 100 230 120]);
            add_block('simulink/Signal Routing/Switch', ...
                [blockPath '/Switch'], 'Threshold', '0.5', ...
                'Position', [240 50 270 80]);
            add_block('simulink/Sources/Constant', ...
                [blockPath '/OFF'], 'Value', '0', 'Position', [200 10 230 30]);
            add_line(blockPath, 'In1/1', 'OR/1');
            add_line(blockPath, 'In2/1', 'OR/2');
            add_line(blockPath, 'OR/1', 'Switch/1');
            add_line(blockPath, 'OFF/1', 'Switch/2');
            add_line(blockPath, 'LED/1', 'Switch/3');
            add_line(blockPath, 'Switch/1', 'Out1/1');

        otherwise
            add_block('simulink/Logic and Bit Operations/Logical Operator', ...
                [blockPath '/AND'], 'Operator', 'AND', 'Position', [200 60 230 100]);
            add_line(blockPath, 'In1/1', 'AND/1');
            add_line(blockPath, 'In2/1', 'AND/2');
            add_line(blockPath, 'AND/1', 'Out1/1');
    end

    close_system(blockPath);
    y = y + yOffset;
end

save_system(modelName);
disp(['✅ Model ', modelName, '.slx created successfully.']);
