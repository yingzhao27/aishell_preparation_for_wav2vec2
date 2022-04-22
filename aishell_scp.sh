#!/bin/bash

#合并成[id file text]
data_set="train test dev"
for dtask in ${data_set}; do
	awk '{print $2}' data/${dtask}/text_new > data/${dtask}/text_column_2.txt
	paste -d " " data/${dtask}/wav.scp data/${dtask}/text_column_2.txt >data/${dtask}/together.txt
done