
 allImages2 = imageDatastore('LesionClasses', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  trainingImages = imageDatastore('train', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  testImages = imageDatastore('test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   
  

 allImages2 = shuffle(allImages2);



k = 7; % number of folds

partStores{k} = [];
for i = 1:k
   temp = partition(allImages2, k, i);
   partStores{i} = temp.Files;
end

% this will give us some randomization
% though it is still advisable to randomize the data before hand
idx = crossvalind('Kfold', k, k);

for i = 1:k
    test_idx = (idx == i);
    train_idx = ~test_idx;

    test_Store = imageDatastore(partStores{test_idx}, 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    train_Store = imageDatastore(cat(1, partStores{train_idx}), 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
    

    % do your training and predictions here, maybe pre-allocate them before the loop, too
    %net{i} = trainNetwork(train_Store, layers options);
    %pred{i} = classify(net, test_Store);
  
    net = resnet18;
    
    options = trainingOptions('sgdm', ...
    'MaxEpochs',8, ...
    'Shuffle','every-epoch', ...
    'ValidationData',test_Store, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');
    net2 = trainNetwork(train_Store,lgraph_4,options);
   % net = trainNetwork(imdsTrain,layers,options);

   % YPred = classify(net,imdsValidation);
   % YValidation = imdsValidation.Labels;
    
% accuracy = sum(YPred == YValidation)/numel(YValidation)
end   















   
   