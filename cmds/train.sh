#!/bin/bash

current_dir=`dirname $0`

. $current_dir/env_vars

arch="gnmt_v2"
encoder_type="gnmt"

model_name="SGD_BPE_B10_L8_N1024_"${arch}"_"${encoder_type}

mkdir $modles_home/${model_name}

export PYTHONPATH=$nmt_home

nohup python3 -m nmt.nmt --src=${src} --tgt=${tgt} --vocab_prefix=$corpus_home/vocab.bpe --train_prefix=$corpus_home/train.bpe --dev_prefix=$corpus_home/newsdev2017.bpe --test_prefix=$corpus_home/newstest2017.bpe --out_dir=$modles_home/${model_name} --src_max_len=80 --tgt_max_len=80 --num_train_steps=240000 --steps_per_stats=100 --optimizer=sgd --learning_rate=1.0 --beam_width=10 --num_gpus=4 --num_layers=8 --num_units=1024 --batch_size=128 --dropout=0.2 --metrics=bleu,rouge,accuracy --attention=scaled_luong --attention_architecture=${arch} --encoder_type=${encoder_type} >> $modles_home/${model_name}.log &