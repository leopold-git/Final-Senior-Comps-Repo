
% ALEXNET MODEL


 allImages2 = imageDatastore('LesionClasses', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  trainingImages = imageDatastore('train', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  testImages = imageDatastore('test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   

% randomize images 
 allImages2 = shuffle(allImages2);
% split set into training and test -- 80:20 split
 [imdsTraining,imdsTest] = splitEachLabel(allImages2,0.8,'randomized');
 [imdsTrain,imdsValidation] = splitEachLabel(imdsTraining,0.8,'randomized');
  auimdsTrain = augmentedImageDatastore([224 224 3],imdsTrain);
  auimdsVal= augmentedImageDatastore([224 224 3],imdsValidation);
  auimdsTest= augmentedImageDatastore([224 224 3],imdsTest);

    % do your training and predictions here, maybe pre-allocate them before the loop, too
   
    % define number of labels
    numClasses = numel(categories(imdsTrain.Labels));
    % model uses AlexNet
     res = resnet50;
     
lgraph = layerGraph(res);

newFCLayer = fullyConnectedLayer(numClasses,'Name','new_fc','WeightLearnRateFactor',10,'BiasLearnRateFactor',10);
lgraph = replaceLayer(lgraph,'fc1000',newFCLayer);

newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'ClassificationLayer_predictions',newClassLayer);

    
  


    % network parameters
    opts = trainingOptions('sgdm', ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-3, ...% changed from 10^-4
    'Shuffle','every-epoch', ...
    'ValidationData',auimdsVal, ...
    'ValidationFrequency',5, ...
    'ValidationPatience',4,...
    'Verbose',false, ...
    'Plots','training-progress');
     

    resModel = trainNetwork(auimdsTrain, lgraph, opts);
    save resModel;

  

  

    
  








    %% 
    load resModel;
        analyzeNetwork(resModel)

 YPred = classify(resModel, auimdsTest);
  Probs = predict(resModel, auimdsTest);
 

    accuracy = mean(YPred == imdsTest.Labels)
    
   
  cat = categorical(C);
numer = 0;
negative = 0;
truePos = 0;
trueNeg = 0;
toalMel= 0;
    % false positive 
    for i=1:size(imdsTest.Labels, 1)
        
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
    
    sens = truePos/ toalMel
    
    spec = trueNeg / (numer + trueNeg)







   
   