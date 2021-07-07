import click
import duckdb
from vocabaqdata.import_tools import import_tsv, setup_import


@click.command()
@click.argument("users_tsv", type=click.Path(exists=True))
@click.argument("answers_tsv", type=click.Path(exists=True))
@click.argument("db_out", type=click.Path())
def main(users_tsv, answers_tsv, db_out):
    conn = duckdb.connect(db_out)
    setup_import(conn)

    print("Creating tables")
    conn.execute("""
    create table users_native (
        user_id int,
        datetime datetime,
        year_born int,
        month_born int,
        gender int,
        verbal_sat int
    );
    create table answers_native (
        user_id int,
        rank int,
        known int
    );
    """)

    import_tsv(conn, "users_native", users_tsv)
    import_tsv(conn, "answers_native", answers_tsv)


if __name__ == "__main__":
    main()
