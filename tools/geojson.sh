#!/bin/sh

toolsDir="./tools"

# create tmp dir
mkdir -p ./tmp
rm -f ./tmp/*

rm -rf ./out
mkdir -p ./out

worldSize=$(ndjson-cat meta.json | ndjson-map 'd.worldSize')

for filePath in ./geojson/*.json; do
    fileName=$(basename $filePath)
    layer=${fileName%.*}

    # find tippecanoe settings for current layer
    settingsCmd="ndjson-cat $toolsDir/layer_settings.json | ndjson-split 'd' | ndjson-filter 'd.layer === \"$layer\"'"
    tippecanoeSettings=$(eval $settingsCmd)

    echo "➡️  Starting layer $layer"
    cmd="ndjson-cat $filePath | ndjson-split 'd' | ndjson-map -r toLonLat=$toolsDir/armaToLonLat 'd.tippecanoe = $tippecanoeSettings, d.properties = {}, d.geometry = toLonLat($worldSize, d.geometry) , d'"
    eval $cmd | ndjson-reduce > ./out/$layer.geojson
    echo "✔️  Finished layer $layer"
done

# clean up
rm -rf ./tmp