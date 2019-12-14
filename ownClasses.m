
 allImages = imageDatastore('LesionClasses', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  trainingImages = imageDatastore('train', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  testImages = imageDatastore('test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   
  allImages = shuffle(allImages);

   
% What is the size of my images?    
img = readimage(allImages,1);
size(img)



k = 7; % number of folds

partStores{k} = [];
for i = 1:k
   temp = partition(allImages, k, i);
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
    layers = [ 
    imageInputLayer([450 600 3])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
  
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(7)
    softmaxLayer
    classificationLayer];

    options = trainingOptions('sgdm', ...
        'InitialLearnRate',0.01, ...
        'MaxEpochs',4, ...
        'Shuffle','every-epoch', ...
        'ValidationData',test_Store, ...
        'ValidationFrequency',30, ...
        'Verbose',false, ...
        'Plots','training-progress');

    net = trainNetwork(train_Store,layers,options);

    YPred = classify(net,test_Store);
    YValidation = test_Store.Labels;
    
accuracy = sum(YPred == YValidation)/numel(YValidation)
end   





%{







% Building the CNN / Adding layers
layers = [
    imageInputLayer([450 600 3])
    
    convolution2dLayer(3,8,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
    
    convolution2dLayer(3,16,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,'Stride',2)
  
    
    convolution2dLayer(3,32,'Padding','same')
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(7)
    softmaxLayer
    classificationLayer];

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',4, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress');

net = trainNetwork(imdsTrain,layers,options);

   
  %}

   
   