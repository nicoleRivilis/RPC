%this is the main function that runs all the code, largely focused on
%creating figures for the RPC paper and presentation

%the final function should read the seizure filename, start, end, and fs
%from here, but for now i'm just testing on one of them that plots nicely
[num,txt,raw] = xlsread('Freiburg_Seizure_information.xlsx');

%will also eventually modify things to not always plot plots because i
%don't need 85 figures, tyvm

load('010403aa_0021Sz.mat')

Fs = 256;

szStart = 767172;
szEnd = 802660;

%plot original data
RPCplotEEGfig(data, Fs, szStart, szEnd);

%plot effect of notch filter and returns filtered data and spectrums
[filteredData, spectrums] = RPCfilter(data, Fs);

subStart = 741377;
subEnd = 802816;

subData = filteredData(subStart:subEnd, :);
%it takes 6 minutes to process 120 windows, where each window is 2 seconds
%of data, 4 minutes total. so it takes about 1.5 times as long to process
%as the length of the actual data. each 1-hour file will presumably take
%1.5 hours to process, even with first-order arima features

%labels is NOT currently working but features is!
[features, labels] = RPCgenFeats(subData, szStart, szEnd);

RPCplotFeats(features, subData, szStart, szEnd, subStart, subEnd, Fs);


%for SVM input need numFramesx36 input
%Gaussian kernel
%k = 10 for validation for param selection grid search

%svmModel=fitcsvm(features,labels,('KFold', 10, 'KernelFunction', 'gaussian')
%try linear too if you want

%KFsigma = 5*10^(-5)



