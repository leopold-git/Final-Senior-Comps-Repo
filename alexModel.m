
% ALEXNET MODEL


 allImages2 = imageDatastore('LesionClasses', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  trainingImages = imageDatastore('train', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
 %  testImages = imageDatastore('test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   

% randomize images 
 allImages2 = shuffle(allImages2);
% split set into training and test -- 80:20 split
 [imdsTraining,imdsTest] = splitEachLabel(allImages2,0.8,'randomized');
 [imdsTrain,imdsValidation] = splitEachLabel(imdsTraining,0.8,'randomized');
  auimdsTrain = augmentedImageDatastore([227 227 3],imdsTrain);
  auimdsVal= augmentedImageDatastore([227 227 3],imdsValidation);
  auimdsTest= augmentedImageDatastore([227 227 3],imdsTest);

    % do your training and predictions here, maybe pre-allocate them before the loop, too
   
    % define number of labels
    numClasses = numel(categories(imdsTrain.Labels));
    % model uses AlexNet
    alex = alexnet;
    layersTransfer = alex.Layers(1:end-3);

    % adjust input to fit alexnet requirements
 
    
    layers = [
    layersTransfer
    fullyConnectedLayer(numClasses,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
    softmaxLayer
    classificationLayer];


    % network parameters
    opts = trainingOptions('sgdm', ...
    'MaxEpochs',6, ...
    'InitialLearnRate',1e-3, ...% changed from 10^-4
    'Shuffle','every-epoch', ...
    'ValidationData',auimdsVal, ...
    'ValidationFrequency',3, ...
    'ValidationPatience',4,...
    'Verbose',false, ...
    'Plots','training-progress');
     

    myNet = trainNetwork(auimdsTrain, layers, opts);
    save myNet

  

  

    
  








    %% 
    load myNet;
    analyzeNetwork(myNet)
 YPred = classify(myNet, auimdsTest);
  Probs = predict(myNet, auimdsTest);

    accuracy = mean(YPred ==  imdsTest.Labels)
   cat = categorical(C);
numer = 0;
negative = 0;
truePos = 0;
trueNeg = 0;
toalMel= 0;
    % false positive 
    for i=1:size(imdsTest.Labels, 1)
        num1 = imdsTest.Labels(i) ~= 'akiec';
        num2 = YPred(i) == 'akiec';
        if imdsTest.Labels(i) ~= 'akiec' & YPred(i) == 'akiec'
            numer = numer +1;
        end
        
        if imdsTest.Labels(i) == 'akiec' & YPred(i) ~= 'akiec'
            negative = negative +1;
        end
       
        if imdsTest.Labels(i) == 'akiec' & YPred(i) == 'akiec'
            truePos = truePos +1;
        end
         if imdsTest.Labels(i) ~= 'akiec' & YPred(i) ~= 'akiec'
            trueNeg = trueNeg +1;
        end
        

      
    end
 
    toalMel = sum(imdsTest.Labels =='akiec');
    falsePos = numer / toalMel;
    falseNeg = negative / toalMel;
    
    sens = truePos/ (truePos + negative)
    
    spec = trueNeg / (numer + trueNeg)





   
   