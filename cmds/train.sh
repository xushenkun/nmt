#!/bin/bash

current_dir=`dirname $0`

. $current_dir/env_vars

export arch="standard"

export model_name=${model_pair}"_bpe_"${arch}

mkdir $modles_home/${model_name}

export PYTHONPATH=$nmt_home

nohup python3 -m nmt.nmt --src=${src} --tgt=${tgt} --vocab_prefix=$corpus_home/${model_pair}/vocab.bpe --train_prefix=$corpus_home/${model_pair}/train.bpe --dev_prefix=$corpus_home/${model_pair}/newsdev2017.bpe --test_prefix=$corpus_home/${model_pair}/newstest2017.bpe --out_dir=$modles_home/${model_name} --num_train_steps=12000 --steps_per_stats=100 --optimizer=sgd --learning_rate=1.0 --beam_width=10 --num_gpus=4 --num_layers=4 --num_units=512 --dropout=0.2 --metrics=bleu --attention=scaled_luong --attention_architecture=${arch} >> $modles_home/log_${model_name}.out &