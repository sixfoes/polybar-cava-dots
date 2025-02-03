#! /bin/bash

config_file="/tmp/$(whoami)_cava_config"
pipe="/tmp/$(whoami)-cava.fifo"

if [ -p $pipe ]; then
    unlink $pipe
fi
mkfifo $pipe

echo "
[general]
bars = $1
lower_cutoff_freq = 20

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = $pipe
data_format = ascii
ascii_max_range = 5
" > $config_file

cava -p $config_file &

while read -r cmd; do
    echo $cmd | sed "s/;//g;"
done < $pipe

