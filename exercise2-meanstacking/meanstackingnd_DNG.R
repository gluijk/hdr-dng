# Building DNG RAW files from Bayer TIFF data
# Exercise 2: mean stacking
# www.overfitting.net
# https://www.overfitting.net/2024/03/apilado-por-media-para-simular-iso.html

library(tiff)


# PARAMETERS
N=14  # number of RAW files to merge
NAME="DSC0"  # input RAW filenames
INIT=5408  # first file
OUTNAME="bayer"  # output RAW composite filename
BLACK=512  # sensor black level (Sony A7 II)
SAT=16383  # sensor sat level (Sony A7 II)


# READ RAW DATA

# RAW integer extraction using DCRAW: dcraw -v -D -t 0 -4 -T *.dng
# IMPORTANT: note that -D DCRAW extraction instead of -d is used
img=0
for (i in 1:N) {
    name=paste0(NAME, i+INIT-1, ".tiff")
    img=img+readTIFF(name, native=FALSE, convert=FALSE, as.is=TRUE)
    print(paste0(i, " / ", N, " added ", name))
}

# MEAN AVERAGING
img=img/N  # averaging


# BUILD OUTPUT DNG

# Normalize RAW data
img=img-BLACK  # subtract black level
img[img<0]=0  # clip negative values
img=img/(SAT-BLACK)  # normalize to 0..1
hist(img, breaks=1024)

if (max(img)<1) print(paste0("Output ETTR'ed by: +",
                             round(-log(max(img),2),2), "EV"))
writeTIFF(img/max(img), paste0(OUTNAME,".tif"), bits.per.sample=16,
          compression="none")

