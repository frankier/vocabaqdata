import click

import pandas

from ..feats.freq import add_zipfs


@click.command()
@click.argument("lang")
@click.argument("df_in", type=click.Path(exists=True))
@click.argument("df_out", type=click.Path())
def main(lang, df_in, df_out):
    df = pandas.read_parquet(df_in)
    add_zipfs(df, lang=lang)
    df.to_parquet(df_out)


if __name__ == "__main__":
    main()
