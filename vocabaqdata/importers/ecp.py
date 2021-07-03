import click
import duckdb
from vocabaqdata.import_tools import import_tsv, setup_import


@click.command()
@click.argument("profiles_tsv", type=click.Path(exists=True))
@click.argument("decisions_tsv", type=click.Path(exists=True))
@click.argument("sessions_tsv", type=click.Path(exists=True))
@click.argument("db_out", type=click.Path())
def main(profiles_tsv, decisions_tsv, sessions_tsv, db_out):
    conn = duckdb.connect(db_out)
    setup_import(conn)

    print("Creating tables")
    conn.execute("""
    create table profiles (
        profile_id int,
        browser_id int,
        ua_id int,
        gender varchar,
        age int,
        country varchar,
        education varchar,
        native_language varchar,
        level_english varchar,
        no_foreign_lang int,
        best_foreign varchar,
        handedness varchar
    );
    create table decisions (
        trial_id int,
        exp_id int,
        trial_order int,
        spelling string,
        lexicality varchar,
        rt int,
        accuracy bool,
        response varchar,
        rt_adjbox bool,
        rt_zscore float
    );
    create table sessions (
        exp_id int,
        time_start datetime,
        time_end datetime,
        profile_id int,
        ua_id int,
        touch bool,
        nw_acc float,
        w_acc float,
        score float,
        profile_id_session int
    );
    """)

    import_tsv(conn, "profiles", profiles_tsv)
    import_tsv(conn, "decisions", decisions_tsv)
    import_tsv(conn, "sessions", sessions_tsv)


if __name__ == "__main__":
    main()
