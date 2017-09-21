#!/bin/bash

current_dir=`dirname $0`

. $current_dir/env_vars

export arch="standard"

export model_name="SGD_BPE_B10_L4_N512_"${arch}

mkdir $modles_home/${model_name}

export PYTHONPATH=$nmt_home

nohup python3 -m nmt.nmt --src=${src} --tgt=${tgt} --vocab_prefix=$corpus_home/vocab.bpe --train_prefix=$corpus_home/train.bpe --dev_prefix=$corpus_home/newsdev2017.bpe --test_prefix=$corpus_home/newstest2017.bpe --out_dir=$modles_home/${model_name} --num_train_steps=24000 --steps_per_stats=100 --optimizer=sgd --learning_rate=1.0 --beam_width=10 --num_gpus=4 --num_layers=4 --num_units=512 --batch_size=128 --dropout=0.2 --metrics=bleu --attention=scaled_luong --attention_architecture=${arch} >> $modles_home/${model_name}.log &