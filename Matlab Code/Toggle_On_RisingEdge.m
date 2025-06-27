model = 'Toggle_On_RisingEdge_Fixed';
new_system(model);
open_system(model);

% Add blocks
add_block('simulink/Sources/In1', [model '/In1']);
add_block('simulink/Discrete/Delay', [model '/Delay']);
add_block('simulink/Logic and Bit Operations/Compare To Constant', [model '/Compare1'], 'const', '1');
add_block('simulink/Logic and Bit Operations/Compare To Zero', [model '/Compare0']);
add_block('simulink/Logic and Bit Operations/Logical Operator', [model '/AND'], ...
          'Operator', 'AND', 'Inputs', '2');
add_block('simulink/Discrete/Memory', [model '/Memory']);
add_block('simulink/Logic and Bit Operations/Logical Operator', [model '/XOR'], ...
          'Operator', 'XOR', 'Inputs', '2');
add_block('simulink/Sinks/Out1', [model '/Out1']);

% Set positions (just for visual layout)
set_param([model '/In1'], 'Position', [30 50 60 70]);
set_param([model '/Delay'], 'Position', [100 50 130 70]);
set_param([model '/Compare1'], 'Position', [100 20 130 40]);
set_param([model '/Compare0'], 'Position', [100 80 130 100]);
set_param([model '/AND'], 'Position', [160 50 190 70]);
set_param([model '/Memory'], 'Position', [230 90 260 110]);
set_param([model '/XOR'], 'Position', [290 60 320 80]);
set_param([model '/Out1'], 'Position', [360 60 390 80]);

% Add connections
add_line(model, 'In1/1', 'Delay/1');
add_line(model, 'In1/1', 'Compare1/1');
add_line(model, 'Delay/1', 'Compare0/1');
add_line(model, 'Compare1/1', 'AND/1');
add_line(model, 'Compare0/1', 'AND/2');
add_line(model, 'AND/1', 'XOR/1');
add_line(model, 'Memory/1', 'XOR/2');
add_line(model, 'XOR/1', 'Out1/1');
add_line(model, 'XOR/1', 'Memory/1');

% Save and close system
save_system(model);
% close_system(model);
