import click
import pandas
from more_itertools import unique_justseen


@click.command()
@click.argument("resps", type=click.File("rb"))
@click.argument("respwords", type=click.File("w"))
def main(resps, respwords):
    df = pandas.read_parquet(resps)
    for word in unique_justseen(sorted(df["word"])):
        respwords.write(word.lower())
        respwords.write("\n")


if __name__ == "__main__":
    main()
