function RPCplotFeats(features, subData, szStart, szEnd, subStart, subEnd, Fs)
%szstart and end should be replaced by labels but i haven't tested those
%yet
[samples, channels] = size(subData);

time = (1:samples)/Fs;

sztime = (szStart-subStart: szEnd-subStart)/(Fs);

featN = (1:length(features))*2;
%times 2 because each feature represents 2 seconds (512 samples at 256 Hz)

maxN = max(featN);



xline = (szStart-subStart)/Fs;

featmin = min(min(features));
featmax = max(max(features));
datamin = min(min(subData));
datamax = max(max(subData));

figure()


subplot(7,2,1)
plot(featN, features, 'Color', [0.6 0.6 0.6])
hold on
plot(featN, mean(features,2),'k', 'LineWidth', 2)
hold on
line([xline xline], [featmin(1), featmax(1)], 'Color','k','LineStyle',':', 'LineWidth', 2)
title('First-Order AR Feature Over Time')
ylabel('Mean')
xlim([0 maxN])
ylim([featmin 1])
set(gca, 'XTickLabel', [])


subplot(7,2,2)
plot(time, mean(subData,2), 'Color', [0.6 0.6 0.6])
hold on
plot(sztime, mean(subData(szStart-subStart: szEnd-subStart, :),2), 'k')
hold on
line([xline xline], [datamin(1), datamax(1)], 'Color','k','LineStyle',':', 'LineWidth', 2)
title('Recorded Data, with Seizure in Black')
xlim([0 maxN])
ylim([datamin(1) datamax(1)])
set(gca, 'XTickLabel', [])
ylabel('Mean')


for i = 1:channels
    
    subplot(7,2,i*2-1+2)
    plot(featN, features(:,i), 'Color', [0.6 0.6 0.6])
    hold on
    line([xline xline], [featmin(1), featmax(1)], 'Color','k','LineStyle',':', 'LineWidth', 2)
    ylabel(['Ch. ' num2str(i)])
    set(gca, 'YTickLabel', [])
    if i == channels
        xlabel('Time (seconds)')
    else
        set(gca, 'XTickLabel', [])
    end
    xlim([0 maxN])
    ylim([featmin 1])
    
    subplot(7,2,i*2+2)
    plot(time, subData(:,i), 'Color', [0.6 0.6 0.6])
    hold on
    plot(sztime, subData(szStart-subStart: szEnd-subStart,i), 'k')
    hold on
    line([xline xline], [datamin(1), datamax(1)], 'Color','k','LineStyle',':', 'LineWidth', 2)
    set(gca, 'YTickLabel', [])
    ylabel(['Ch. ' num2str(i)])
    
    if i == channels
        xlabel('Time (seconds)')
    else
        set(gca, 'XTickLabel', [])
    end
    xlim([0 maxN])
    ylim([datamin(1) datamax(1)])
    
end

suptitle(sprintf('ARIMA Feature Results'))

end