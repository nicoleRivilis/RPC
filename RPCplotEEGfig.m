function RPCplotEEGfig(data, Fs, szStart, szEnd)

[samples, channels] = size(data);

time = (1:samples)/(Fs*60);

sztime = (szStart:szEnd)/(Fs*60);

figure()

for i = 1:channels
    
    subplot(6,1,i)
    plot(time, data(:,i), 'Color', [0.6 0.6 0.6])
    hold on
    plot(sztime, data(szStart:szEnd,i), 'k')
    ylabel(['Ch. ' num2str(i)])
    set(gca, 'YTickLabel', [])
    if i == channels
        xlabel('Time (minutes)')
    else
        set(gca, 'XTickLabel', [])
    end
end

suptitle(sprintf('Example of a 6-Channel EEG Recording \n with Seizure Highlighted in Black'))
end