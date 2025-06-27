% Clean start
modelName = 'ButtonHold2SecondsCheck_v2';
new_system(modelName);
open_system(modelName);

% Parameters
sampleTime = 0.1;
holdTimeSec = 2;
countThreshold = holdTimeSec / sampleTime; % = 20

% Add blocks
add_block('simulink/Sources/In1', [modelName '/Button'], 'Position', [30 100 60 120]);

add_block('simulink/Math Operations/Add', [modelName '/Add'], 'Position', [130 90 160 110]);

add_block('simulink/Discrete/Unit Delay', [modelName '/Delay'], ...
    'Position', [100 140 130 160], 'SampleTime', num2str(sampleTime));

add_block('simulink/Commonly Used Blocks/Constant', [modelName '/1'], ...
    'Value', '1', 'Position', [100 60 130 80]);

add_block('simulink/Commonly Used Blocks/Constant', [modelName '/0'], ...
    'Value', '0', 'Position', [100 180 130 200]);

add_block('simulink/Signal Routing/Switch', [modelName '/Switch'], ...
    'Position', [180 100 210 140], 'Threshold', '0.5');

add_block('simulink/Logic and Bit Operations/Compare To Constant', ...
    [modelName '/Compare'], ...
    'const', num2str(countThreshold), ...
    'relop', '>=', ...
    'Position', [250 100 290 120]);

add_block('simulink/Sinks/Out1', [modelName '/ValidPress'], 'Position', [330 100 360 120]);

% Connect blocks
add_line(modelName, 'Button/1', 'Switch/1');
add_line(modelName, '1/1', 'Switch/2');
add_line(modelName, '0/1', 'Switch/3');
add_line(modelName, 'Switch/1', 'Add/1');
add_line(modelName, 'Delay/1', 'Add/2');
add_line(modelName, 'Add/1', 'Delay/1');
add_line(modelName, 'Add/1', 'Compare/1');
add_line(modelName, 'Compare/1', 'ValidPress/1');

% Save and open
save_system(modelName);
disp("✅ Model created and saved as: ButtonHold2SecondsCheck_v2.slx");
