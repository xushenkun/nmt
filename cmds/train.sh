#!/bin/bash


cd /application/search/tf/gnmt/nmt_git_12

export model_name="zh_en_bpe_standard"

nohup python3 -m nmt.nmt --src=zh --tgt=en --vocab_prefix=../corpus/en_zh/vocab.bpe --train_prefix=../corpus/en_zh/train.bpe --dev_prefix=../corpus/en_zh/newsdev2017.bpe --test_prefix=../corpus/en_zh/newstest2017.bpe --out_dir=../models/${model_name} --num_train_steps=12000 --steps_per_stats=100 --optimizer=sgd --learning_rate=1.0 --beam_width=10 --num_gpus=4 --num_layers=4 --num_units=512 --dropout=0.2 --metrics=bleu --attention=scaled_luong --attention_architecture=standard >> nohup_${model_name}.out &