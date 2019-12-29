function [freq,ampl] = SimpleFFT(sig,fps)

% signal length
L = length(sig);

% accessible frequency domain
freq = fps*(0:L/2)/L;

fftres = abs(fft(sig)/L);
ampl = fftres(1:L/2+1);

ampl(2:end-1) = 2*ampl(2:end-1);

end


