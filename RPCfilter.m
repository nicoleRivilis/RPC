function [filteredData, spectrums] = RPCfilter(data, Fs)

[L, channels] = size(data);

spectrums = zeros(L/2+1, channels);
filteredData = zeros(L, channels);

%filter the data and generate figure demonstrating notch and noise removal
f = Fs*(0:(L/2))/L;

figure()

for i = 1:channels
    thisChan = data(:,i);
    
    Yorig = fft(thisChan);
    Pdoub = abs(Yorig/L);
    specO = Pdoub(1:L/2+1);
    specO(2:end-1) = 2*specO(2:end-1);
    subplot(6,2,i*2-1)
    plot(f, specO, 'k')
    xlim([40 60])
    ylim([0 2])
    ylabel(['Ch. ' num2str(i)])
    
    set(gca, 'YTickLabel', [])
    if i == channels
        xlabel('Frequency (Hz)')
    else
        set(gca, 'XTickLabel', [])
    end
    
    Xt = RPCpreprocessing(thisChan, Fs);
    Y = fft(Xt);
    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);
    
    subplot(6,2,i*2)
    plot(f,P1, 'k')
    xlim([40 60])
    ylim([0 2])
    set(gca, 'YTickLabel', [])
    if i == channels
        xlabel('Frequency (Hz)')
    else
        set(gca, 'XTickLabel', [])
    end
    
    %save some data for later
    spectrums(:,i) = P1;
    filteredData(:,i) = Xt;
end

suptitle('Comparison of Data Before and After Notch Filtering')



end