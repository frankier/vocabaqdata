import click
import pandas


@click.command()
@click.argument("inf")
@click.argument("outf")
def main(inf, outf):
    pandas.read_excel(inf).to_parquet(outf)


if __name__ == "__main__":
    main()
