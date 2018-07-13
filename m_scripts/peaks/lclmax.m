function pk = lclmax(x,p2)%LCLMAX                            [ A.K.Booer  3-Dec-1992 ]%%  pk = lclmax(x,p)   1-D peak search down columns%                     using peak half window width of p.%% Returns PK, a BOOLEAN matrix showing local maxima positions.%p = 2*p2 + 1;          % full window width[n,m] = size(x);       % useful dimensionsz = zeros(p2,m);       % pre-allocate resulti = toeplitz(p:-1:1,p:n);    % shift operator%y = zeros(p,(n-p+1)*m);      % temporary matrixy(:) = x(i,:);         % index into original data matrixma = max(y);                 % find maximum in window%pk = [z ; reshape(ma,n-p+1,m) ; z]; % add missing edge elementspk = pk == x;                 % find matching elements