import math
from functools import partial

import numpy as np
import pandas
from wordfreq import word_frequency, zipf_frequency

MAX_CBPACK = 800


def add_freq_ranks(df):
    words = df["word"].unique()
    freqs = {}
    rank_freqs = []
    for word in words:
        freq = word_frequency(word, "en")
        freqs[word] = freq
        rank_freqs.append((freq, word))
    df["frequency"] = df["word"].map(freqs)
    rank_freqs.sort(reverse=True)
    word_ranks = {}
    for idx, (_, word) in enumerate(rank_freqs):
        word_ranks[word] = idx + 1
    df["rank"] = df["word"].map(word_ranks)


def print_df(df):
    with pandas.option_context("display.max_rows", None, "display.max_columns", None):
        print(df)


def get_frequency_strata(words, num_strata=5):
    word_grouped = words.groupby(words)
    freqs = []
    for word, indices in word_grouped.indices.items():
        freqs.append((word_frequency(word, "en"), indices))
    freqs.sort(key=lambda tpl: tpl[0])
    strata = np.empty(len(words))
    level_size = int(math.ceil(len(freqs) / num_strata))
    for stratum_idx, start in enumerate(range(0, len(freqs), level_size)):
        for _, indices in freqs[start : start + level_size]:
            strata[indices] = stratum_idx
    return strata


def add_freq_strata(df, num_strata=5):
    df["stratum"] = get_frequency_strata(df["word"], num_strata=num_strata)
    df["stratum"] = df["stratum"].astype(int)


def get_word_buckets():
    from wordfreq import get_frequency_list

    for idx, bucket in enumerate(get_frequency_list("en")):
        for word in bucket:
            yield word, idx


def add_zipfs(df, lang="en"):
    df["zipf"] = df["word"].map(partial(zipf_frequency, lang=lang))
