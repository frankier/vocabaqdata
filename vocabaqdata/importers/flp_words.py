import click
import pandas


@click.command()
@click.argument("inf")
@click.argument("outf")
def main(inf, outf):
    df = pandas.read_excel(inf)
    df["item"] = df["item"].astype("string")
    df.to_parquet(outf)


if __name__ == "__main__":
    main()
