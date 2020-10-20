%% get input
[filename,filepath]=uigetfile('file selector');
inputpath=strcat([filepath,filename]);
input_image=imread(inputpath);
%% get training data
imageFolder = fullfile('signs');
imds = imageDatastore(imageFolder, 'LabelSource', 'foldernames', 'IncludeSubfolders',true);
tbl = countEachLabel(imds);
minSetCount = min(tbl{:,2}); 
% Use splitEachLabel method to trim the set.
imds = splitEachLabel(imds, minSetCount, 'randomize');
% Notice that each set now has exactly the same number of images.
countEachLabel(imds)
limit40 = find(imds.Labels == 'limit40', 1);
schoolzone = find(imds.Labels == 'schoolzone', 1);
serviceroadend = find(imds.Labels == 'serviceroadend', 1);
speedbreaker = find(imds.Labels == 'speedbreaker', 1);
workersunderprocess = find(imds.Labels == 'workersunderprocess', 1);
%% intialize network
net = resnet50();
net.Layers(1)
net.Layers(end)
% Number of class names for ImageNet classification task
numel(net.Layers(end).ClassNames)
%to tarin and test
[trainingSet, testSet] = splitEachLabel(imds, 0.3, 'randomize');
imageSize = net.Layers(1).InputSize;
augmentedTrainingSet = augmentedImageDatastore(imageSize, trainingSet, 'ColorPreprocessing', 'gray2rgb');
augmentedTestSet = augmentedImageDatastore(imageSize, testSet, 'ColorPreprocessing', 'gray2rgb');
featureLayer = 'fc1000';
trainingFeatures = activations(net, augmentedTrainingSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');
trainingLabels = trainingSet.Labels;
%% select classifier
classifier = fitcecoc(trainingFeatures, trainingLabels, ...
    'Learners', 'Linear', 'Coding', 'onevsall', 'ObservationsIn', 'columns');
testFeatures = activations(net, augmentedTestSet, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');
% Pass CNN image features to trained classifier
predictedLabels = predict(classifier, testFeatures, 'ObservationsIn', 'columns');
% Get the known labels
testLabels = testSet.Labels;
% Tabulate the results using a confusion matrix.
confMat = confusionmat(testLabels, predictedLabels);
% Convert confusion matrix into percentage form
confMat = bsxfun(@rdivide,confMat,sum(confMat,2));
mean(diag(confMat));
%newimage=imread(x);
%process the  image
ds= augmentedImageDatastore(imageSize, input_image, 'ColorPreprocessing', 'gray2rgb');
imagefeature = activations(net, ds, featureLayer, ...
    'MiniBatchSize', 32, 'OutputAs', 'columns');
%% predict output
op = predict(classifier,imagefeature, 'ObservationsIn', 'columns');
display(op)
delete(instrfindall);
instrfind

if(op=='limit40')
    x=serial('COM7','BaudRate',9600,'TimeOut',10,'Terminator','LF');
    fopen(x);
	pause(5);
    fprintf(x,'A');
elseif(op=='schoolzone')
    x=serial('COM7','BaudRate',9600,'TimeOut',10,'Terminator','LF');
    fopen(x);
	pause(5);
    fprintf(x,'B');
elseif(op=='serviceroadend')
    x=serial('COM7','BaudRate',9600,'TimeOut',10,'Terminator','LF');
    fopen(x);
	pause(5);
    fprintf(x,'C');
elseif(op=='speedbreaker')
    x=serial('COM7','BaudRate',9600,'TimeOut',10,'Terminator','LF');
    fopen(x);
	pause(5);
    fprintf(x,'D');
    receive=fgets(x);
    display(receive);
elseif(op=='workersunderprocess')
    x=serial('COM7','BaudRate',9600,'TimeOut',10,'Terminator','LF');
    fopen(x);
	pause(5);
    fprintf(x,'E');   
end
fclose(x);