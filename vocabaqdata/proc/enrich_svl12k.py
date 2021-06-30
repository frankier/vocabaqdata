import sys

import pandas

from ..utils.freq import add_zipfs

df = pandas.read_parquet(sys.argv[1])
add_zipfs(df)
df = df[df["respondent"] != 0]
df["known"] = df["score"] >= 5
df["unknown"] = df["score"] < 5
df.reset_index(drop=True, inplace=True)
df.to_feather(sys.argv[2])
