%------------------------------------------------------------
% ICA

load mix.dat	% load mixed sources
Fs = 11025; %sampling frequency being used

% listen to the mixed sources
normalizedMix = 0.99 * mix ./ (ones(size(mix,1),1)*max(abs(mix)));

wavwrite(normalizedMix(:, 1), Fs, 16, 'mix1.wav');
wavwrite(normalizedMix(:, 2), Fs, 16, 'mix2.wav');
wavwrite(normalizedMix(:, 3), Fs, 16, 'mix3.wav');
wavwrite(normalizedMix(:, 4), Fs, 16, 'mix4.wav');
wavwrite(normalizedMix(:, 5), Fs, 16, 'mix5.wav');


W=eye(5);	% initialize unmixing matrix

% this is the annealing schedule I used for the learning rate.
% (We used stochastic gradient descent, where each value in the 
% array was used as the learning rate for one pass through the data.)
% Note: If this doesn't work for you, feel free to fiddle with learning
%  rates, etc. to make it work.
anneal = [0.1 0.1 0.1 0.05 0.05 0.05 0.02 0.02 0.01 0.01 ...
      0.005 0.005 0.002 0.002 0.001 0.001];

for iter=1:length(anneal)
  m =size(mix, 1);
  order = randperm(m);
  for i = 1:m
    X = mix(order(i), :)';
    g = 1 ./ (1 + exp(-W * X));
    W = W + anneal(iter) * ((1 - 2 * g) * X' + inv(W'));
  end
   %%%% here comes your code part (should not be much, ours was about 10 lines of code)

end;


%%%% After finding W, use it to unmix the sources.  Place the unmixed sources 
%%%% in the matrix S (one source per column).  (Your code.) 

S = mix * W' ;
S=0.99 * S./(ones(size(mix,1),1)*max(abs(S))); 	% rescale each column to have maximum absolute value 1 

% now have a listen --- You should have the following five samples:
% * Godfather
% * Southpark
% * Beethoven 5th
% * Austin Powers
% * Matrix (the movie, not the linear algebra construct :-) 

wavwrite(S(:, 1), Fs, 16, 'unmix1.wav');
wavwrite(S(:, 2), Fs, 16, 'unmix2.wav');
wavwrite(S(:, 3), Fs, 16, 'unmix3.wav');
wavwrite(S(:, 4), Fs, 16, 'unmix4.wav');
wavwrite(S(:, 5), Fs, 16, 'unmix5.wav');

