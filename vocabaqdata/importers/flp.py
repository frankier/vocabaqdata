import click
import duckdb
from vocabaqdata.import_tools import setup_import


def create_view(ddb):
    ddb.execute("""
    create view decision_view as
    select
        exp_id as participant,
        case
            when lexicality = 'mot' then 'W'
            else 'N'
        end as lexicality,
        case
            when lexicality = 'mot' AND accuracy = 1 then 'W'
            when lexicality = 'nonmot' AND accuracy = 1 then 'N'
            when lexicality = 'mot' AND accuracy = 0 then 'N'
            else 'W'
        end as response,
        accuracy,
        spelling
    from
        decisions;
    """)


@click.command()
@click.argument("decisions")
@click.argument("pseudowords")
@click.argument("words")
@click.argument("dbout")
def main(decisions, pseudowords, words, dbout):
    ddb = duckdb.connect(dbout)
    setup_import(ddb)
    ddb.execute(f"""
    create table decisions as select * from parquet_scan('{decisions}');
    create table pseudowords as select * from parquet_scan('{pseudowords}');
    create table words as select * from parquet_scan('{words}');
    """)
    create_view(ddb)


if __name__ == "__main__":
    main()
