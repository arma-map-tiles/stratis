#!/bin/sh

dir="out/"
files=`find ./$dir -type f -name "*.geojson" -printf "/data/%f "`

rm -rf ./$dir/tiles

# echo $files
dockerCmd="docker run -it --rm -v $PWD/$dir:/data tippecanoe:latest"
tippecanoeCmd="tippecanoe --no-feature-limit --no-tile-size-limit --cluster-distance=2 --output-to-directory /data/tiles/ --maximum-zoom=8 --minimum-zoom=0 $files"

cmd="$dockerCmd $tippecanoeCmd"

echo "RUNNING: $cmd"

echo "➡️  Starting conversion from geojson to mapbox vector tiles"

eval $cmd

echo "✔️  Finished conversion from geojson to mapbox vector tiles"