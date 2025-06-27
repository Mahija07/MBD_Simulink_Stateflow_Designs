function led_switch_final_model()
    model = 'LED_Switch_Model';
    new_system(model); open_system(model);

    %% Parameters
    Ts = '1';

    %% Add Constant Inputs
    add_block('simulink/Sources/Constant', [model '/Switch1'], ...
        'Value', '0', 'Position', [30 50 60 70]);
    add_block('simulink/Sources/Constant', [model '/Switch2'], ...
        'Value', '0', 'Position', [30 130 60 150]);

    %% Add Detect Change blocks
    add_block('simulink/Logic and Bit Operations/Detect Change', [model '/Detect1'], ...
        'Position', [100 50 130 70]);
    add_block('simulink/Logic and Bit Operations/Detect Change', [model '/Detect2'], ...
        'Position', [100 130 130 150]);

    %% Constants to indicate source
    add_block('simulink/Sources/Constant', [model '/ID1'], ...
        'Value', '1', 'Position', [160 50 190 70]);
    add_block('simulink/Sources/Constant', [model '/ID2'], ...
        'Value', '2', 'Position', [160 130 190 150]);

    %% Switch logic
    add_block('simulink/Signal Routing/Switch', [model '/Switch1Logic'], ...
        'Criteria', 'u2 ~= 0', 'Threshold', '0.5', 'Position', [220 50 260 70]);
    add_block('simulink/Signal Routing/Switch', [model '/Switch2Logic'], ...
        'Criteria', 'u2 ~= 0', 'Threshold', '0.5', 'Position', [220 130 260 150]);

    %% Final Decision
    add_block('simulink/Signal Routing/Switch', [model '/FinalSwitch'], ...
        'Criteria', 'u2 ~= 0', 'Threshold', '0.5', 'Position', [300 90 340 120]);
    add_block('simulink/Discrete/Unit Delay', [model '/LastPressed'], ...
        'SampleTime', Ts, 'Position', [370 90 400 120]);

    %% LED Output
    add_block('simulink/Logic and Bit Operations/Compare To Constant', [model '/LEDCheck'], ...
        'const', '1', 'relop', '==', 'Position', [420 90 470 120]);
    add_block('simulink/Sinks/Display', [model '/LED'], ...
        'Position', [500 90 550 120]);

    %% Add lines
    add_line(model, 'Switch1/1', 'Detect1/1');
    add_line(model, 'Switch2/1', 'Detect2/1');

    add_line(model, 'ID1/1', 'Switch1Logic/1');
    add_line(model, 'Detect1/1', 'Switch1Logic/2');
    add_line(model, 'LastPressed/1', 'Switch1Logic/3');

    add_line(model, 'ID2/1', 'Switch2Logic/1');
    add_line(model, 'Detect2/1', 'Switch2Logic/2');
    add_line(model, 'Switch1Logic/1', 'Switch2Logic/3');

    add_line(model, 'Switch2Logic/1', 'FinalSwitch/1');
    add_line(model, 'Detect2/1', 'FinalSwitch/2');
    add_line(model, 'LastPressed/1', 'FinalSwitch/3');

    add_line(model, 'FinalSwitch/1', 'LastPressed/1');
    add_line(model, 'LastPressed/1', 'LEDCheck/1');
    add_line(model, 'LEDCheck/1', 'LED/1');

    %% Sim Settings
    set_param(model, 'Solver', 'FixedStepDiscrete');
    set_param(model, 'FixedStep', Ts);
    set_param(model, 'StopTime', '20');

    save_system(model);
    disp("✅ Simulink model 'LED_Switch_Model' is created and ready. Change constant values during sim to test.");
end
