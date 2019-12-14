
 allImages2 = imageDatastore('LesionClasses', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  trainingImages = imageDatastore('train', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  testImages = imageDatastore('test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   
  
% randomize images 
 allImages2 = shuffle(allImages2);



k = 10; % number of folds

partStores{k} = [];
for i = 1:k
   temp = partition(allImages2, k, i);
   partStores{i} = temp.Files;
end

% this will give us some randomization
% though it is still advisable to randomize the data before hand
% 10 fold cross validation
idx = crossvalind('Kfold', k, k);

for i = 1:k
    test_idx = (idx == i);
    train_idx = ~test_idx;
    % define test and training data
    test_Store = imageDatastore(partStores{test_idx}, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    train_Store = imageDatastore(cat(1, partStores{train_idx}), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    

    % do your training and predictions here, maybe pre-allocate them before the loop, too
    %net{i} = trainNetwork(train_Store, layers options);
    %pred{i} = classify(net, test_Store);
    numClasses = numel(categories(train_Store.Labels));
    alex = alexnet;
    layersTransfer = alex.Layers(1:end-3);

 
    layersTransfer(1) = imageInputLayer([450 600 3]);
        
  
    layersTransfer(17) = fullyConnectedLayer(7);
    layersTransfer(20) = fullyConnectedLayer(7);
    layersTransfer(23) = fullyConnectedLayer(7);
    
    layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];


    % network parameters
    opts = trainingOptions('sgdm', ...
    'MiniBatchSize',10, ...
    'MaxEpochs',6, ...
    'InitialLearnRate',0.1, ...     % changed from 10^-4
    'Shuffle','every-epoch', ...
    'ValidationData',test_Store, ...
    'ValidationFrequency',3, ...
    'Verbose',false, ...
    'Plots','training-progress');
        % add regularizer   

    myNet = trainNetwork(train_Store, layers, opts);
    
   
    % predict and assess accuracy 
    
    YPred = classify(alex, test_Store);
    accuracy = mean(predictedLabels ==  test_Store.Labels)
    
    
        idx = randperm(numel(imdsValidation.Files),4);
    figure
    for i = 1:4
        subplot(2,2,i)
        I = readimage(imdsValidation,idx(i));
        imshow(I)
        label = YPred(idx(i));
        title(string(label));
    end

    
end   















   
   