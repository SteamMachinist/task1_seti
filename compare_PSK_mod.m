clear;
signal;
EbNoVec = -2:1:21;
steps=1e8;
SERVec_PSK = [];
load_system('compare_psk');
opts = simset('SrcWorkspace','Current','DstWorkspace','Current');
set_param('compare_psk/AWGN Channel PSK','EsNodB','EbNodB+10*log10(6)');
set_param('compare_psk/Error Rate Calculation PSK','numErr','1e4');
set_param('compare_psk/Error Rate Calculation PSK','maxBits','steps');

for n = 1:length(EbNoVec)
    fprintf (1, 'Running %2d ;ap from %d\n', n, length(EbNoVec));
    EbNodB = EbNoVec(n);
    sim('compare_psk', steps, opts);
    SERVec_PSK(n,:) = PSK_SER;
    semilogy(EbNoVec(n), SERVec_PSK(n,1), 'go-');
    hold on;
    drawnow;
end

hold off;

%a = 2 * 2 * rad2deg(pi/8)/2;

P = 64 * 2 * erfc(sqrt(6*a^2/A*(10.^(EbNoVec./10))));

PSK_an = P/(2 * 64);

semilogy(EbNoVec, SERVec_PSK(:,1), 'go', EbNoVec, PSK_an, 'mx:', 'LineWidth', 1.2);
set(gca, ...
'XAxisLocation', 'bottom', ...
'XTickMode', 'auto', ...
'YTickMode', 'auto', ...
'FontSize', 14, ...
'FontName', 'Arial Unicode MS', ...
'Box', 'on');
legend('PSK simulation', 'PSK analitical', 'SouthWest');
grid off;
xlabel('Eb/No (dB)', 'FontSize', 14); 
ylabel('SER', 'FontSize', 14);
hold off;



