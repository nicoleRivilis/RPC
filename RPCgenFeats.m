function [features, labels] = RPCgenFeats(filteredData, szStart, szEnd)
%get the ARMA coefficients
N = 512; %2*256: 2-second windows, can assume stationary over this

%if i'm reading the paper right, it's 6 and 1?
p = 1;

%fuck: getting error message “the non-seasonal autoregressive polynomial is 
%unstable”, which means that some of the eigenvalues of the AR part of the 
%series are outside the unit circle, creating non-stationarity
%if i got the error “the non-seasonal moving average polynomial is 
%non-invertible” it would mean an explosion of the MA roots, which is also
%bad

%retrying with lower order--original was 6. 3 was also bad.





q = 1;

[numSamples, channels] = size(filteredData);

windows = numSamples/N; %1800

disp(['Number of Windows: ' num2str(windows)])

features = zeros(windows, channels*p);
labels = zeros(windows, 1);
%need to loop over all 6 channels, all data in 2-sec windows

for j = 1:windows
    disp(['Current Window: ' num2str(j)])
    for i = 1:channels
        
        currentData = filteredData((j-1)*N+1:j*N,i);
        
        %(ar, i, ma): p is the ar model order, i is zero, q is the ma model order
        %i think if i'm reading the paper right it's (6, 0, 1) but idk
        %zero is because assuming stationarity in the 2-sec time window, I think
        [model, ~, ~, ~] = estimate(arima(p,0,q), currentData, 'Display', 'off');
        %displays a ton of params by default
        
        feats = cell2mat(model.AR); %silly MATLAB functions do things in cell arrays
        
        features(j, 1+(i-1)*p:i*p) = feats;
    end
    
    %mark as seizure if the window is entirely between the szStart and
    %szEnd points
    label = 1+(j-1)*N>=szStart & j*N <=szEnd;
    
    labels(j) = label;
    
end

%if i want to get the 1st coefficient of each channel i would do
%features([1,7,13,19,25,31],:)

%plot evolution of first AR coefficient for all 6 channels in grey
%plot mean over channels in black
%add dashed vertical line to indicate seizure onset time

end