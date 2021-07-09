import click

import pandas

from ..feats.freq import add_zipfs


@click.command()
@click.argument("df_in", type=click.Path(exists=True))
@click.argument("df_out", type=click.Path())
@click.option("--lang", default="en")
def main(df_in, df_out, lang):
    df = pandas.read_parquet(df_in)
    add_zipfs(df, lang=lang)
    df.to_parquet(df_out)


if __name__ == "__main__":
    main()
