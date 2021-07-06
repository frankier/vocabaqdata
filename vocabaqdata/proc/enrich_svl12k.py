import click

import pandas

from ..feats.freq import add_zipfs


@click.command()
@click.argument("df_in", type=click.Path(exists=True))
@click.argument("df_out", type=click.Path())
def main(df_in, df_out):
    df = pandas.read_parquet(df_in)
    add_zipfs(df)
    df = df[df["respondent"] != 0]
    df["known"] = df["score"] >= 5
    df["unknown"] = df["score"] < 5
    df.reset_index(drop=True, inplace=True)
    df.to_parquet(df_out)


if __name__ == "__main__":
    main()
