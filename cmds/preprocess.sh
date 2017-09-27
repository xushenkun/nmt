#!/bin/bash

current_dir=`dirname $0`

. $current_dir/env_vars

echo "prepare corpus train..."
cd $corpus_home
pwd
#unzip datum2017.zip
#cd datum2017
#cat Book1_cn.txt Book2_cn.txt Book3_cn.txt Book4_cn.txt Book5_cn.txt Book6_cn.txt Book7_cn.txt Book8_cn.txt Book9_cn.txt Book10_cn.txt > $corpus_home/train.zh
#cat Book1_en.txt Book2_en.txt Book3_en.txt Book4_en.txt Book5_en.txt Book6_en.txt Book7_en.txt Book8_en.txt Book9_en.txt Book10_en.txt > $corpus_home/train.en
unzip casict2015.zip
cd casict2015
mv casict2015_ch.txt $corpus_home/train.zh
mv casict2015_en.txt $corpus_home/train.en

echo "prepare corpus dev..."
for year in 2017;
do
  $moses_scripts/ems/support/input-from-sgm.perl < $corpus_home/dev/newsdev${year}-zhen-ref.en.sgm > $corpus_home/newsdev$year.en
  $moses_scripts/ems/support/input-from-sgm.perl < $corpus_home/dev/newsdev${year}-zhen-src.zh.sgm > $corpus_home/newsdev$year.zh
done

echo "prepare corpus test..."
for year in 2017;
do
  $moses_scripts/ems/support/input-from-sgm.perl < $corpus_home/test/newstest${year}-zhen-ref.en.sgm > $corpus_home/newstest$year.en
  $moses_scripts/ems/support/input-from-sgm.perl < $corpus_home/test/newstest${year}-zhen-src.zh.sgm > $corpus_home/newstest$year.zh
done

echo "tokenize corpus..."
for prefix in train newsdev2017 newstest2017
 do
   export PYTHONPATH=$jieba_home
   cat $corpus_home/$prefix.zh | python3 -m jieba -d | \
   $moses_scripts/tokenizer/normalize-punctuation.perl -l zh | \
   $moses_scripts/tokenizer/tokenizer.perl -a -threads 8 -l zh > $corpus_home/$prefix.tok.zh
   cat $corpus_home/$prefix.en | \
   $moses_scripts/tokenizer/normalize-punctuation.perl -l en | \
   $moses_scripts/tokenizer/tokenizer.perl -a -threads 8 -l en > $corpus_home/$prefix.tok.en
 done

echo "clean and case corpus..."
$moses_scripts/training/clean-corpus-n.perl $corpus_home/train.tok zh en $corpus_home/train.tok.clean 1 100
$moses_scripts/recaser/train-truecaser.perl -corpus $corpus_home/train.tok.clean.zh -model $modles_home/truecase-model.zh
$moses_scripts/recaser/train-truecaser.perl -corpus $corpus_home/train.tok.clean.en -model $modles_home/truecase-model.en
$moses_scripts/recaser/truecase.perl -model $modles_home/truecase-model.zh < $corpus_home/train.tok.clean.zh > $corpus_home/train.tc.zh
$moses_scripts/recaser/truecase.perl -model $modles_home/truecase-model.en < $corpus_home/train.tok.clean.en > $corpus_home/train.tc.en
for prefix in newsdev2017 newstest2017
 do
  $moses_scripts/recaser/truecase.perl -model $modles_home/truecase-model.zh < $corpus_home/$prefix.tok.zh > $corpus_home/$prefix.tc.zh
  $moses_scripts/recaser/truecase.perl -model $modles_home/truecase-model.en < $corpus_home/$prefix.tok.en > $corpus_home/$prefix.tc.en
 done

echo "make bpe for corpus..."
$bpe_home/learn_joint_bpe_and_vocab.py -i $corpus_home/train.tc.zh $corpus_home/train.tc.en --write-vocabulary $corpus_home/vocab.zh $corpus_home/vocab.en -s $bpe_operations -o $modles_home/zhen.bpe

echo "make vocab for corpus..."
if [ "$use_bpe" = "1" ]; then
  for prefix in train newsdev2017 newstest2017
   do
    $bpe_home/apply_bpe.py -c $modles_home/zhen.bpe --vocabulary $corpus_home/vocab.zh --vocabulary-threshold $bpe_threshold < $corpus_home/$prefix.tc.zh > $corpus_home/$prefix.bpe.zh
    $bpe_home/apply_bpe.py -c $modles_home/zhen.bpe --vocabulary $corpus_home/vocab.en --vocabulary-threshold $bpe_threshold < $corpus_home/$prefix.tc.en > $corpus_home/$prefix.bpe.en
   done
   
  echo "make dictionary for corpus..."
  echo -e "<unk>\n<s>\n</s>" > "${corpus_home}/vocab.bpe"
  cat "${corpus_home}/train.bpe.zh" "${corpus_home}/train.bpe.en" | ${bpe_home}/get_vocab.py | cut -f1 -d ' ' >> "${corpus_home}/vocab.bpe"
  cp "${corpus_home}/vocab.bpe" "${corpus_home}/vocab.bpe.zh"
  cp "${corpus_home}/vocab.bpe" "${corpus_home}/vocab.bpe.en"
else
  echo "make dictionary for corpus..."
  echo -e "<unk>\n<s>\n</s>" > "${corpus_home}/vocab.zh"
  cat "${corpus_home}/train.tc.zh" | ${bpe_home}/get_vocab.py | cut -f1 -d ' ' >> "${corpus_home}/vocab.zh"
  echo -e "<unk>\n<s>\n</s>" > "${corpus_home}/vocab.en"
  cat "${corpus_home}/train.tc.en" | ${bpe_home}/get_vocab.py | cut -f1 -d ' ' >> "${corpus_home}/vocab.en"
fi

echo "preprocess over!"