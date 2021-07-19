import click
import duckdb
from vocabaqdata.import_tools import import_tsv, setup_import


def create_view(conn):
    conn.execute("""
    create view decision_view as
    select
        participant,
        lexicality,
        r as response,
        corrn as accuracy,
        spelling
    from sessions
    where
        warmup = 0
        and is_imputed = 0;
    """)


@click.command()
@click.argument("list1_tsv", type=click.Path(exists=True))
@click.argument("list2_tsv", type=click.Path(exists=True))
@click.argument("db_out", type=click.Path())
def main(list1_tsv, list2_tsv, db_out):
    conn = duckdb.connect(db_out)
    setup_import(conn)

    print("Creating tables")
    conn.execute("""
    create table sessions (
        participant int,
        list int,
        block int,
        subblock int,
        trial_in_subblock int,
        trial_in_block int,
        trial int,
        observation int,
        warmup int,
        repetition int,
        item int,
        pair int,
        spelling varchar,
        lexicality varchar,
        handedness varchar,
        xrb varchar,
        one int,
        rb varchar,
        r varchar,
        corr varchar,
        corrn int,
        is_missing int,
        is_error int,
        is_bad_item int,
        is_lt_200 int,
        is_gt_1999 int,
        is_lt_lower int,
        is_gt_upper int,
        is_imputed int,
        lower float,
        upper float,
        rtR float,
        rateR float,
        rtC float,
        rateC float,
        rtI float,
        rateI float,
        zrtC float,
        zrateC float,
        zrtI float,
        zrateI float
    );
    """)

    import_tsv(conn, "sessions", list1_tsv, null="NA")
    import_tsv(conn, "sessions", list2_tsv, null="NA")

    create_view(conn)


if __name__ == "__main__":
    main()
