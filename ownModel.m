
% CUSTOM MODEL


 allImages2 = imageDatastore('LesionClasses', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  trainingImages = imageDatastore('train', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  testImages = imageDatastore('test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   

% randomize images 
 allImages2 = shuffle(allImages2);
% split set into training and test -- 80:20 split
 [imdsTraining,imdsTest] = splitEachLabel(allImages2,0.8,'randomized');
 [imdsTrain,imdsValidation] = splitEachLabel(imdsTraining,0.8,'randomized');
  auimdsTrain = augmentedImageDatastore([450 600 3],imdsTrain);
  auimdsVal= augmentedImageDatastore([450 600 3],imdsValidation);
  auimdsTest= augmentedImageDatastore([450 600 3],imdsTest);

    % do your training and predictions here, maybe pre-allocate them before the loop, too
   
    % define number of labels
    numClasses = numel(categories(imdsTrain.Labels));
  % define layers 
    layers = [ 
    imageInputLayer([450 600 3])    % size is original size of images
    
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
    
    fullyConnectedLayer(numClasses);
    softmaxLayer
    classificationLayer];
    
    
  
    % network parameters
    opts = trainingOptions('sgdm', ...
    'MaxEpochs',6, ...
    'InitialLearnRate',0.1, ...% changed from 10^-4
    'Shuffle','every-epoch', ...
    'ValidationData',auimdsVal, ...
    'ValidationFrequency',5, ...
    'ValidationPatience',4,...
    'Verbose',false, ...
    'Plots','training-progress');
     

    own = trainNetwork(auimdsTrain, layers, opts);
    save own;

  

  

    
  








    %% 
    % load trained model
    load own;
    analyzeNetwork(own);
    % predict images and calculate accuracy
 [YPred, scores] = classify(own, auimdsTest);
 Probs = predict(own, auimdsTest);
 accuracy = mean(YPred == imdsTest.Labels);
  cat = categorical(C);
  
  % calculate sensitivity and specificity for a given lesion class
numer = 0;
negative = 0;
truePos = 0;
trueNeg = 0;
toalMel= 0;
    % false positive 
    for i=1:size(imdsTest.Labels, 1)
        num1 = imdsTest.Labels(i) ~= 'bcc';
        num2 = YPred(i) == 'bcc';
        if imdsTest.Labels(i) ~= 'bcc' && YPred(i) == 'bcc'
            numer = numer +1;
        end
        
        if imdsTest.Labels(i) == 'bcc' && YPred(i) ~= 'bcc'
            negative = negative +1;
        end
       
        if imdsTest.Labels(i) == 'bcc' && YPred(i) == 'bcc'
            truePos = truePos +1;
        end
         if imdsTest.Labels(i) ~= 'bcc' && YPred(i) ~= 'bcc'
            trueNeg = trueNeg +1;
        end
        

      
    end
 
    toalMel = sum(imdsTest.Labels =='bcc');
    falsePos = numer / toalMel;
    falseNeg = negative / toalMel;
    % sensitivity and specificity
    sens = truePos/ (truePos + negative)
    
    spec = trueNeg / (numer + trueNeg)




   
   