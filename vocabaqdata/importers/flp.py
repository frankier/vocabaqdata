import click
import duckdb
from vocabaqdata.import_tools import setup_import


@click.command()
@click.argument("decisions")
@click.argument("pseudowords")
@click.argument("words")
@click.argument("dbout")
def main(decisions, pseudowords, words, dbout):
    ddb = duckdb.connect(dbout)
    setup_import(ddb)
    ddb.execute(f"""
    CREATE TABLE decisions AS SELECT * FROM parquet_scan('{decisions}');
    CREATE TABLE pseudowords AS SELECT * FROM parquet_scan('{pseudowords}');
    CREATE TABLE words AS SELECT * FROM parquet_scan('{words}');
    """)


if __name__ == "__main__":
    main()
