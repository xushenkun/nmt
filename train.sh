
cd /application/search/tf/gnmt/nmt_git_12
nohup python3 -m nmt.nmt --src=zh --tgt=en --vocab_prefix=../corpus/en_zh/vocab --train_prefix=../corpus/en_zh/train --dev_prefix=../corpus/en_zh/valid --test_prefix=../corpus/en_zh/test --out_dir=../models/zh_en --num_train_steps=12000 --steps_per_stats=100 --optimizer=sgd --learning_rate=1.0 --beam_width=10 --num_gpus=4 --num_layers=4 --num_units=512 --dropout=0.2 --metrics=bleu --attention=scaled_luong --attention_architecture=gnmt_v2 &