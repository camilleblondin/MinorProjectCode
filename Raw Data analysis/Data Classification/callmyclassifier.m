function  [trainedClassifier, validationAccuracy] =  callmyclassifier(Classifiername,trainingdataSet)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

%[trainedClassifier, validationAccuracy] = myClassifier(trainingdataSet);
%classifiers {'Fine knn', 'Weighted knn', 'LDA', 'SVM' , 'cubic SVM' };

switch Classifiername
    case 'Fine knn'
        disp('Fine Knn Classifier: ');
        [trainedClassifier, validationAccuracy] = myknnFineClassifier(trainingdataSet);
        disp('Validation accuracy : ');
        validationAccuracy
        
    case 'Weighted knn'
        disp('Weighted Knn Classifier: ');
        [trainedClassifier, validationAccuracy] = myknnWeightedClassifier(trainingdataSet);
        disp('Validation accuracy : ');
        validationAccuracy
    case 'LDA'
        disp('LDA Classifier: ');
        [trainedClassifier, validationAccuracy] = myLDAClassifier(trainingdataSet);
        disp('Validation accuracy : ');
        validationAccuracy
    case 'SVM'
        disp('SVM Classifier: ');
        [trainedClassifier, validationAccuracy] = mySVMClassifier(trainingdataSet);
        disp('Validation accuracy : ');
        validationAccuracy
    case 'cubic SVM'
        disp('Cubic SVM Classifier: ');
        [trainedClassifier, validationAccuracy] = mySVMCubicClassifier(trainingdataSet);
        disp('Validation accuracy : ');
        validationAccuracy
end


end

