function [mim] = FindParticleImg(tr,imdir,mimsize)
% Returns averaged particle image, computed from imaged stored in imdir, in
% an image of size imsize, with the particle located in the middle.

% (1) assumes tr.pix, particle pixel positions, are loaded into tr structure

% (2) RAM-friendly version, much faster would be to input pre-loaded images

% find images, assuming they are correctly labeled
files = dir([imdir '/*.tif']);

% find original image size
orsize = size(imread(files(1).name));

% image buffer, 2*imsize larger than image size
im = zeros(orsize+2*mimsize);

% mean image to be returned
mim = zeros(2*mimsize+1);

% load frame-by-frame and calculate mean image
for i = 1:tr.length
    
    % load image into buffer
    im(mimsize+(1:orsize(1)),mimsize+(1:orsize(2))) = imread(files(tr.fr(i)).name);
    
    % add data to be averaged
    mim = mim + im((0:2*mimsize)+tr.pix(i,2),(0:2*mimsize)+tr.pix(i,1));
    
end

% calculate average image
mim = mim./tr.length;

end
    
