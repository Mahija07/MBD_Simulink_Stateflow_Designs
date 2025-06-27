function create_LED_Blinker_NoPulse()
    modelName = 'LED_Blinker_NoPulse';
    
    % Close if already open
    if bdIsLoaded(modelName)
        close_system(modelName, 0);
    end

    % Create and open new model
    new_system(modelName);
    open_system(modelName);

    % Add Clock block
    add_block('simulink/Sources/Clock', [modelName '/Clock'], ...
        'Position', [100, 100, 130, 130]);

    % Add Gain (for 2*pi frequency)
    add_block('simulink/Math Operations/Gain', [modelName '/Gain'], ...
        'Gain', '2*pi', ...
        'Position', [160, 100, 190, 130]);

    % Add Trigonometric Function block
    add_block('simulink/Math Operations/Trigonometric Function', [modelName '/Sine'], ...
        'Operator', 'sin', ...
        'Position', [220, 100, 250, 130]);

    % Add Compare To Constant block
    add_block('simulink/Logic and Bit Operations/Compare To Constant', [modelName '/Compare'], ...
        'relop', '>=', ...
        'const', '0', ...
        'Position', [280, 100, 310, 130]);

    % Add Scope
    add_block('simulink/Sinks/Scope', [modelName '/Scope'], ...
        'Position', [350, 100, 400, 130]);

    % Connect the blocks
    add_line(modelName, 'Clock/1', 'Gain/1');
    add_line(modelName, 'Gain/1', 'Sine/1');
    add_line(modelName, 'Sine/1', 'Compare/1');
    add_line(modelName, 'Compare/1', 'Scope/1');

    % Save and open the model
    save_system(modelName);
    open_system(modelName);
end
