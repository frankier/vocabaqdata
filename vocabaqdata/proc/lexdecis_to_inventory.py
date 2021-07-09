import click
import duckdb


def mk_select(table, participant):
    return f"""
    select
        {participant} as respondent,
        spelling as word,
        response = 'W' as known,
        response != 'W' as unknown
    from {table}
    where lexicality = 'W' and {participant} in (
        select {participant}
        from {table}
        where lexicality = 'N'
        group by {participant}
        having cast(sum(cast(accuracy as int)) as double) / count(*) > ?
    )
    """


@click.command()
@click.argument("db_in", type=click.Path(exists=True))
@click.argument("df_out", type=click.Path())
@click.option("--thresh", type=float, default=0.95)
@click.option(
    "--fmt",
    type=click.Choice(["blp", "ecp", "flp", "spalex", "elp"]),
    required=True
)
def main(db_in, df_out, thresh, fmt):
    if db_in.endswith(".parquet"):
        conn = duckdb.connect()
        conn.execute(
            f"create view decisions as select * from parquet_scan('{db_in}');"
        )
    else:
        conn = duckdb.connect(db_in)
    if fmt == "blp":
        table = "trials"
        participant = "participant"
    elif fmt == "ecp":
        table = "decisions"
        participant = "exp_id"
    elif fmt in ("flp", "spalex"):
        table = "decision_view"
        participant = "participant"
    elif fmt == "elp":
        from vocabaqdata.importers.elp import create_view
        create_view(conn)
        table = "decision_view"
        participant = "participant"
    else:
        assert False
    select_query = mk_select(table, participant)
    conn.execute(f"""
    COPY (
    {select_query}
    ) TO '{df_out}' (FORMAT 'parquet');
    """, [thresh])


if __name__ == "__main__":
    main()
