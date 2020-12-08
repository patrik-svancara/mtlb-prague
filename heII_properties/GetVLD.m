function [vld,ell] = GetVLD(a,a0,df,temp)
% Calculates vortex line density for the given inputs. First input is
% assumed to be a vector, others can be either scalars or vectors.
%
% INPUTS: a    = attenuated SS amplitude [arb. units]
%         a0   = inattenuated SS amplitude [arb. units]
%         df   = peak half-width [Hz]
%         temp = temperature [K]
%
% OUTPUTS: vld = vortex line density [m^(-2)]
%          ell = mean intervortex distace [m]

load('hepak.mat','hepak');

rhoN = interp1(hepak.temp,hepak.rhoN,temp);
rho = interp1(hepak.temp,hepak.rho,temp);
alpha = interp1(hepak.temp,hepak.alpha,temp);
QCIRC = 9.98e-8;

vld = 3 .* pi .* rhoN .* df ./ ( rho .* alpha .* QCIRC ) .* ( ( a0 ./ a ) - 1 );

ell = 1./sqrt(vld);

end