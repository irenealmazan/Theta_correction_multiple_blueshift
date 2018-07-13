function lambdac = comptonshift(lambda,theta)% COMPTONSHIFT Calculate wavelength of Compton photons%% Usage: lambdac=comptonshift(lambda,theta)%% Input: % 	lambda = x-ray wavelength (Angstroms)% 	theta  = half of the scattering angle (degrees)%% Output:% 	lambdac = wavelength of Compton photons (Angstroms)lambdac = lambda + 0.0243*(1-cos(2*theta*pi/180));