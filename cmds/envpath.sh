#!/bin/bash

#global toolkit
export moses_scripts=/application/search/tf/gnmt/mosesdecoder/scripts
export bpe_home=/application/search/tf/gnmt/subword-nmt
export nmt_home=/application/search/tf/gnmt/nmt_git_12
export device=cuda  #cpu #gpu2

#language-pair
export src=zh
export tgt=en
export jieba_home=/application/search/tf/gnmt/jieba
export corpus_home=/application/search/tf/gnmt/corpus/en_zh
export modles_home=/application/search/tf/gnmt/models/en_zh
export bpe_operations=90000
export bpe_threshold=10