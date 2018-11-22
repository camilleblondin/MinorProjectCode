function criterion =  funLDA(xT,yT,xt,yt)
criterion = length(yt)*(getclasserror(yt,predict(fitcdiscr( xT, yT,'DiscrimType', 'linear', 'Gamma', 0, 'FillCoeffs', 'off','ClassNames', [0; 1]), xt)));
end