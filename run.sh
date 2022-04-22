#!/bin/bash


data=/home/zhaoyin
sh ./aishell_data_pre.sh $data/data_aishell/wav $data/data_aishell/transcript

for name in train test dev; do
	python ./split_and_norm.py data/$name/text.org data/$name/text
done

for name in train test dev; do
	python ./text_extra.py data/$name/text data/$name/text_new
done

sh ./aishell_scp.sh
python ./scp_to_csv.py