import click
import duckdb
from vocabaqdata.import_tools import import_tsv, setup_import


def create_view(conn):
    conn.execute("""
    create view decision_view as
    select
        exp_id as participant,
        lexicality,
        response,
        accuracy,
        spelling
    from decisions
    where spelling is not null;
    """)


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
        province varchar,
        education varchar,
        native_language varchar,
        no_foreign_lang int,
        best_foreign varchar,
        best_foreign_level varchar,
        handedness varchar
    );
    create table decisions (
        trial_id int,
        exp_id int,
        spelling string,
        lexicality varchar,
        rt int,
        accuracy bool,
        response varchar,
        trial_order int,
        /* almost bool but contains a few values that are neither 0 nor 1 */
        rt_adjbox int,
        rt_zscore float
    );
    create table sessions (
        exp_id int,
        profile_id int,
        list_id int,
        time_start datetime,
        time_end datetime,
        touch bool,
        ua_id int,
        nw_acc float,
        w_acc float,
        score float,
        profile_id_session int
    );
    """)

    import_tsv(conn, "profiles", profiles_tsv, null="")
    import_tsv(conn, "decisions", decisions_tsv, null="")
    import_tsv(conn, "sessions", sessions_tsv, null="")

    create_view(conn)


if __name__ == "__main__":
    main()
