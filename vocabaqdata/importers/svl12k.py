import os
import re
from os.path import join as pjoin

import click
import pandas

RESPONSE_FN_PAT = re.compile(r"svl12000_inputted_user(\d+).txt")


@click.command()
@click.argument("in_dir")
@click.argument("outf")
def main(in_dir, outf):
    """
    Read the raw response data from Ehara into a DataFrame formatted as a
    paraquet file.
    """
    results = []
    for fn in os.listdir(in_dir):
        match = RESPONSE_FN_PAT.match(fn)
        if not match:
            continue
        resp_num = int(match[1])
        with open(pjoin(in_dir, fn), "r") as fin:
            for line in fin.read().strip().split("\n"):
                line_stripped = line.strip()
                if not line_stripped:
                    continue
                word, score = line_stripped.split()
                if word == "clich":
                    word = "cliché"
                results.append((word, int(score), resp_num))
    df = pandas.DataFrame(results, columns=("word", "score", "respondent"))
    df.to_parquet(outf)


if __name__ == "__main__":
    main()
