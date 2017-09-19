# -*- coding: utf-8 -*-

import sys, codecs
import numpy as np
from tensorflow.contrib import learn



def generate_vocab(corpus_filepath, max_len=100000):
    with codecs.open(corpus_filepath, 'r+', encoding="utf-8") as fi:
        lines = fi.readlines()
        x_text = [line.rstrip("\n").rstrip("\r") for line in lines]
        max_document_length = max([len(x.split(" ")) for x in x_text])
        cv = learn.preprocessing.CategoricalVocabulary(unknown_token="<unk>")
        vocab_processor = learn.preprocessing.VocabularyProcessor(max_document_length, vocabulary=cv)
        x = np.array(list(vocab_processor.fit_transform(x_text)))    
        #vocab_dict = vocab_processor.vocabulary_._mapping
        #sorted_vocab = sorted(vocab_dict.items(), key = lambda x : x[1])
        vocab_freq = vocab_processor.vocabulary_._freq
        sorted_vocab = sorted(vocab_freq.items(), key = lambda x : -x[1])
        vocabulary = list(list(zip(*sorted_vocab))[0])
        all_vocabulary = ['<unk>', '<s>', '</s>']
        all_vocabulary.extend(vocabulary)
        with codecs.open(corpus_filepath+".vocab", 'w+', encoding="utf-8") as fo:
            fo.write("\n".join(all_vocabulary[0:max_len]))

if __name__ == '__main__':
    assert len(sys.argv) >= 2, "Vocab script should have enought arguments like: python3 vocab.py corpus_filepath"
    corpus_filepath = sys.argv[1]
    generate_vocab(corpus_filepath)
