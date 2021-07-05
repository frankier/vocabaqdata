import click
import duckdb


@click.command()
@click.argument("db_in", type=click.Path(exists=True))
@click.argument("df_out", type=click.Path())
@click.option("--thresh", type=float, default=0.95)
def main(db_in, df_out, thresh):
    conn = duckdb.connect(db_in)

    conn.execute(f"""
    COPY (
    select
        participant as respondent,
        spelling as word,
        response = 'W' as known,
        response != 'W' as unknown
    from trials
    where lexicality = 'W' and participant in (
        select participant
        from trials
        where lexicality = 'N'
        group by participant
        having cast(sum(cast(accuracy as int)) as double) / count(*) > ?
    )
    ) TO '{df_out}' (FORMAT 'parquet');
    """, [thresh])


if __name__ == "__main__":
    main()
