#!/bin/bash


set -e
set -u
set -o pipefail

aishell_audio_dir=$1
aishell_text=$2/aishell_transcript_v0.8.txt

train_dir=./local/train
dev_dir=./local/dev
test_dir=./local/test
tmp_dir=./local/tmp

mkdir -p $train_dir
mkdir -p $dev_dir
mkdir -p $test_dir
mkdir -p $tmp_dir

# find wav audio file for train, dev and test resp.
find $aishell_audio_dir -iname "*.wav" > $tmp_dir/wav.flist
n=`cat $tmp_dir/wav.flist | wc -l`
[ $n -ne 141925 ] && \
  echo Warning: expected 141925 data data files, found $n

grep -i "wav/train" $tmp_dir/wav.flist > $train_dir/wav.flist || exit 1;
grep -i "wav/dev" $tmp_dir/wav.flist > $dev_dir/wav.flist || exit 1;
grep -i "wav/test" $tmp_dir/wav.flist > $test_dir/wav.flist || exit 1;

rm -r $tmp_dir

# Transcriptions preparation
for dir in $train_dir $dev_dir $test_dir; do
  echo Preparing $dir transcriptions
  sed -e 's/\.wav//' $dir/wav.flist | awk -F '/' '{print $NF}' > $dir/utt.list
  sed -e 's/\.wav//' $dir/wav.flist | awk -F '/' '{i=NF-1;printf("%s %s\n",$NF,$i)}' > $dir/utt2spk_all
  paste -d' ' $dir/utt.list $dir/wav.flist > $dir/wav.scp_all
  ./filter_scp.pl -f 1 $dir/utt.list $aishell_text > $dir/transcripts.txt
  awk '{print $1}' $dir/transcripts.txt > $dir/utt.list
  ./filter_scp.pl -f 1 $dir/utt.list $dir/utt2spk_all | sort -u > $dir/utt2spk
  ./filter_scp.pl -f 1 $dir/utt.list $dir/wav.scp_all | sort -u > $dir/wav.scp
  sort -u $dir/transcripts.txt > $dir/text.org
done

mkdir -p ./data/train ./data/dev data/test

for f in wav.scp text.org; do
  cp $train_dir/$f ./data/train/$f || exit 1;
  cp $dev_dir/$f ./data/dev/$f || exit 1;
  cp $test_dir/$f ./data/test/$f || exit 1;
done
