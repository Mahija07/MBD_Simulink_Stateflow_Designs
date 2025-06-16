% File: build_TwoWorkingUseCases.m

modelName = 'Working_MBD_UseCases';
new_system(modelName);
open_system(modelName);

% Subsystem 1: Battery Check and Turn ON
block1 = [modelName '/01_BatteryCheckAndTurnOn'];
add_block('simulink/Ports & Subsystems/Subsystem', block1, 'Position', [100, 100, 400, 200]);
open_system(block1);

% Remove defaults
try
    delete_line(block1, 'In1/1', 'Out1/1');
    delete_block([block1 '/In1']);
    delete_block([block1 '/Out1']);
catch; end

% Add custom blocks
add_block('simulink/Sources/In1', [block1 '/BatteryCurrent'], 'Position', [30 40 60 60]);
add_block('simulink/Discrete/Delay', [block1 '/Delay'], 'DelayLength', '5', 'Position', [90 40 130 60]);
add_block('simulink/Logic and Bit Operations/Compare To Constant', ...
    [block1 '/Compare'], 'const', '100', 'relop', '<', 'Position', [170 40 220 60]);
add_block('simulink/Signal Routing/Switch', [block1 '/Switch'], 'Threshold', '0.5', 'Position', [260 40 300 70]);
add_block('simulink/Sources/Constant', [block1 '/LED_ON'], 'Value', '1', 'Position', [140 100 170 120]);
add_block('simulink/Sinks/Out1', [block1 '/Output'], 'Position', [350 60 380 80]);

% Connect
add_line(block1, 'BatteryCurrent/1', 'Delay/1');
add_line(block1, 'Delay/1', 'Compare/1');
add_line(block1, 'Compare/1', 'Switch/2');
add_line(block1, 'LED_ON/1', 'Switch/1');
add_line(block1, 'BatteryCurrent/1', 'Switch/3');
add_line(block1, 'Switch/1', 'Output/1');

close_system(block1);

% Subsystem 2: Dual Switch LED Control
block2 = [modelName '/02_DualSwitch_LEDControl'];
add_block('simulink/Ports & Subsystems/Subsystem', block2, 'Position', [100, 300, 400, 400]);
open_system(block2);

% Remove defaults
try
    delete_line(block2, 'In1/1', 'Out1/1');
    delete_block([block2 '/In1']);
    delete_block([block2 '/Out1']);
catch; end

% Add custom blocks
add_block('simulink/Sources/In1', [block2 '/Switch1'], 'Position', [30 40 60 60]);
add_block('simulink/Sources/In1', [block2 '/Switch2'], 'Position', [30 100 60 120]);
add_block('simulink/Logic and Bit Operations/Logical Operator', ...
    [block2 '/OR'], 'Operator', 'OR', 'Position', [100 60 130 90]);
add_block('simulink/Sources/Constant', [block2 '/LED_ON'], 'Value', '1', 'Position', [170 40 200 60]);
add_block('simulink/Sources/Constant', [block2 '/LED_OFF'], 'Value', '0', 'Position', [170 100 200 120]);
add_block('simulink/Signal Routing/Switch', [block2 '/Switch'], 'Threshold', '0.5', 'Position', [220 60 260 90]);
add_block('simulink/Sinks/Out1', [block2 '/Output'], 'Position', [310 70 340 90]);

% Connect
add_line(block2, 'Switch1/1', 'OR/1');
add_line(block2, 'Switch2/1', 'OR/2');
add_line(block2, 'OR/1', 'Switch/1');
add_line(block2, 'LED_OFF/1', 'Switch/2');
add_line(block2, 'LED_ON/1', 'Switch/3');
add_line(block2, 'Switch/1', 'Output/1');

close_system(block2);

% Save
save_system(modelName);
disp("✅ Created 'Working_MBD_UseCases.slx' with 2 functional subsystems.");
