
function [t,y] = m_waveform(waveType,amp,freq,phase)
      fs = 44100;
      t = 0 : 1/fs : 5 - 1/fs;
     % ok = 0;
     % limit_x=5/freq;
      switch lower(waveType)
        case 'sin'
            y = amp * sin(2 * pi * freq * t + phase);
        case 'square'
            y = amp * sign(sin(2 * pi * freq * t + phase));
        case 'sawtooth'
            y = amp * (2 * mod(freq * t + phase/(2*pi), 1) - 1);
        case 'triangle'
            y = amp * (4 * abs(mod(freq * t + phase/(2*pi) + 0.25, 1) - 0.5) - 1);
        case 'rectangular'
            duty = 0.2;
            y = amp * ((mod(freq * t + phase/(2*pi), 1) < duty) * 2 - 1);
         case 'sinc pulse'
             t_center = 2.5;
             x = 2 * freq * (t - t_center);
             y = sin(pi*x) ./ (pi*x);
             y(x == 0) = 1;
             y= amp * y;
             %ok=1;
         case 'chirp'
             f0 = freq;
             f1 = freq*50;
             k = (f1 - f0) / 5;
             y = amp * sin(2*pi * (f0 + k/2 * t) .* t);
             %ok=2;
         case 'noise'
             y = amp * (2 * rand(size(t)) - 1);
         case 'pulse'
             duty = 0.05; 
             y = amp * (mod(freq * t + phase/(2*pi), 1) < duty);
         case 'dc'
             y = amp * ones(size(t));
           

        otherwise
            error('Unsupported wave type');
      end
      %{
plot(t,y,"LineWidth",1);
      ylim([-1.2*amp 1.2*amp])
      if ok==0
        %ylim([-1.5 1.5]);
        xlim([0, min(limit_x, 5)]);
      elseif ok==1
       % ylim([-1.5 1.5]);
        xlim([2.5-limit_x, 2.5+limit_x]);
      else
        %ylim([-1.5 1.5]);
        limit_x_chirp = 10 / freq; 
         xlim([0, min(limit_x_chirp, 5)]);
      

      end
      grid on;
      xlabel('Time (s)');
      ylabel('Amplitude');
      title(['Waveform: ', waveType]);
      filename = sprintf('%s_Amp%.2f_Freq%d_Phase%.2f.wav', waveType, amp, freq, phase);
      %audiowrite(filename,y,fs);
      %}
end
