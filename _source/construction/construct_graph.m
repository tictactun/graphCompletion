function lGraph = construct_graph(dataX, avaiSampleSet, config, mdl)   
    lGraph.nVertices = size(dataX, 1);    
    % construct graph based on the construction data    
    if config('ensembleMode')
        A = ensemble_graph(dataX, config, mdl);
    else
        A = construct_adjacency(dataX, avaiSampleSet, config, mdl);
    end
    
    % normalize graph
    normA = normalize_matrix(A);    
    %{
    datetime = datestr(now);
    datetime=strrep(datetime,':','_'); %Replace colon with underscore
    datetime=strrep(datetime,'-','_');%Replace minus sign with underscore
    datetime=strrep(datetime,' ','_');%Replace space with underscore
    datetime = strcat('samp_graphs/',datetime,'.mat');      
    save(datetime, 'normA');
    %}
    
    % Calculate Laplacian graph
    [V, D] = construct_laplacian(normA);    
    nBands = ceil(config('rBand') * lGraph.nVertices);    
    lGraph.Vk = V(:, 1:nBands);
    lGraph.Dk = D(1:nBands);  
    
    %{     
    % Plot
    figure(); hold on;
    for i = 1:3
        Vk = V(:, i:i+1);
        A12 = A * Vk;
        subplot(3, 1, i);
        scatter(A12(:, 1), A12(:, 2), 'filled', 'b');
        xlabel(i);
        ylabel(i + 1);
        title('Cheap graph');
    end
    %}
end

% normalized matrix
function normA = normalize_matrix(A)
%     normA =  A - min(A(:));
%     normA = normA ./ max(normA(:));
    normA = A;
end