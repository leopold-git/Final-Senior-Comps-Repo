% creating a simple CNN using pretrained model
net = alexnet;
layers = net.Layers;
layers(1) = imageInputLayer([224 224 3]);
layers(17) = fullyConnectedLayer(2);
layers(20) = fullyConnectedLayer(2);
layers(23) = fullyConnectedLayer(2);

layers(25) = classificationLayer;
%%%%%%%code for resizing


 allImages = imageDatastore('LesionClasses', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   trainingImages = imageDatastore('train', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');
   testImages = imageDatastore('test', 'IncludeSubfolders', true, 'LabelSource', 'foldernames');



[trainingImages, testImages] = splitEachLabel(allImages, 0.8, 'randomize');

%testImages=imageDatastore(inputSize, testImages);
analyzeNetwork(layers)

opts = trainingOptions('sgdm', 'InitialLearnRate',  0.001, 'MaxEpochs' , 20);
myNet = trainNetwork(trainingImages, layers, opts);


%{
predictedLabels = classify(myNet, testImages);
accuracy = mean(predictedLabels == testImages.Labels);
%}



