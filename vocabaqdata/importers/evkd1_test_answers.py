import re

import click
from pandas import DataFrame


@click.command()
@click.argument("inf", type=click.File("r"))
@click.argument("outf", type=click.File("wb"))
def main(inf, outf):
    inside = False
    nums = []
    words = []
    answers = []
    for line in inf:
        if line.startswith('""'):
            inside = True
            continue
        if not inside:
            continue
        num, word, ans = re.split("[ ,]", line.strip())[:3]
        nums.append(int(num.rstrip(".")))
        words.append(word)
        answers.append(ans)
    data = {"num": nums, "word": words, "answer": answers}
    DataFrame(data).to_parquet(outf)


if __name__ == "__main__":
    main()
