function output = aut_xfft_v9_1_mex (din, C_NFFT_MAX, C_ARCH, C_INPUT_WIDTH, C_TWIDDLE_WIDTH )

% Generics for this smoke test
 Generics.C_NFFT_MAX = C_NFFT_MAX;
 Generics.C_ARCH = C_ARCH;
 Generics.C_HAS_NFFT = 0;
 Generics.C_USE_FLT_PT = 0;
 Generics.C_INPUT_WIDTH = C_INPUT_WIDTH; % Must be 32 if Generics.C_USE_FLT_PT = 1
 Generics.C_TWIDDLE_WIDTH = C_TWIDDLE_WIDTH; % Must be 24 or 25 if Generics.C_USE_FLT_PT = 1
 Generics.C_HAS_SCALING = 0; % Set to 0 if Generics.C_USE_FLT_PT = 1
 Generics.C_HAS_BFP = 0; % Set to 0 if Generics.C_USE_FLT_PT = 1
 Generics.C_HAS_ROUNDING = 0; % Set to 0 if Generics.C_USE_FLT_PT = 1

samples = 2^ Generics.C_NFFT_MAX;
din = din./2^( Generics.C_INPUT_WIDTH-1);
% Handle multichannel FFTs if required

  % Create input data frame: constant data
  input_raw(1:samples) = din(1:samples);
  if  Generics.C_USE_FLT_PT == 0
    % Set up quantizer for correct twos's complement, fixed-point format: one sign bit, Generics.C_INPUT_WIDTH-1 fractional bits
    q = quantizer([ Generics.C_INPUT_WIDTH,  Generics.C_INPUT_WIDTH-1], 'fixed', 'convergent', 'saturate');
    % Format data for fixed-point input
    input = quantize(q,input_raw);
  else
    % Floating point interface - use data directly
    input = input_raw;
  end
  
  % Set point size for this transform
  nfft =  Generics.C_NFFT_MAX;
  
  % Set up scaling schedule: scaling_sch[1] is the scaling for the first stage
  % Scaling schedule to 1/N: 
  %    2 in each stage for Radix-4/Pipelined, Streaming I/O
  %    1 in each stage for Radix-2/Radix-2 Lite
  if  Generics.C_ARCH == 1 ||  Generics.C_ARCH == 3
    scaling_sch = ones(1,floor(nfft/2)) * 2;
    if mod(nfft,2) == 1
      scaling_sch = [scaling_sch 1];
    end
  else
    scaling_sch = ones(1,nfft);
  end

  % Set FFT (1) or IFFT (0)
  direction = 1;
  
  % Run the MEX function
  [output, blkexp, overflow] = xfft_v9_1_bitacc_mex(Generics, nfft, input, scaling_sch, direction);
  output = output.';
  output = floor(output.*2^( Generics.C_INPUT_WIDTH-1));

end

