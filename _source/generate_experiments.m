function generate_experiments()
    
    [inputPars, configs] = init();    
    [dataX, dataY] = process_data(inputPars); 
    
    % using cross validation - rmse
    filenames = {'../dataset/data_full.csv'; '../dataset/data702.csv'; ...
        '../dataset/data_roi1.csv'};
    datasets = [1:3]';
    selectionMode = [0; 10];
    learningMode = [0]';
    sparseMode = [80; 90];
    weightedMode = [false; true];
    
    d = [3, 2, 1, 2, 2];
    
    [v5, v4, v3, v2, v1] = ...
        ndgrid(1:d(5), 1:d(4),1:d(3),1:d(2), 1:d(1));
    
    products = [datasets(v1,:), selectionMode(v2,:), learningMode(v3,:), ...
        sparseMode(v4, :), weightedMode(v5, :)];
% 
%     isFirst = true;
%     if isFirst
%         wSet = 1:size(products, 1);
%         product = products;
%     else
%         products = csvread('mat/myExp2.csv', 1, 0);
%         [wSet, ~] = find(isnan(products(:, 6)));
%         product = products(wSet, :);
%     end
    result1 = zeros(size(products, 1), 1);
    result2 = zeros(size(products, 1), 1);
    
    kFolds = 5;
    nIters = 100;
    for i = 1:size(products, 1)
        % clone
        config = configs;
        inputParams = inputPars;
        
        params = products(i, :);
        inputParams('filename') = filenames{params(1)};
        config('nSelected') = params(2);
        config('learningMode') = params(3);
        config('sim') = params(4);
        config('binary') = params(5);
        try 
            [metric_graph, ~] = cross_validation(kFolds, ...
                            nIters, dataX, dataY, inputParams, config, 1);
            result1(i) = metric_graph(5);
            result2(i) = metric_graph(6);
        catch 
            result1(i) = -1;
            result2(i) = -1;
            fprintf('Exception here\n');
        end
    end
%     products(wSet, 6) = result1;
%     products(wSet, 7) = result2;
    T = table(products(:, 1), products(:, 2), products(:, 3), ...
        products(:, 4), products(:, 5), result1, result2);
    writetable(T,'my0.csv','Delimiter', ','); 
end