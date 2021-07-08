import click
import duckdb
from vocabaqdata.import_tools import import_csv, setup_import


@click.command()
@click.argument("word_info_csv", type=click.Path(exists=True))
@click.argument("lexical_csv", type=click.Path(exists=True))
@click.argument("users_csv", type=click.Path(exists=True))
@click.argument("sessions_csv", type=click.Path(exists=True))
@click.argument("db_out", type=click.Path())
def main(word_info_csv, lexical_csv, users_csv, sessions_csv, db_out):
    conn = duckdb.connect(db_out)
    setup_import(conn)

    print("Creating tables")
    conn.execute("""
    create table word_info (
        spelling varchar,
        count_total int,
        percent_total float,
        prevalence_total float,
        count_nts int,
        percent_nts float,
        prevalence_nts float,
        count_ntl int,
        percent_ntl float,
        prevalence_ntl float,
        freq float,
        zipf float
    );
    create table lexical (
        trial_id int,
        exp_id int
        trial_order int,
        spelling varchar,
        lexicality varchar,
        rt int,
        accuracy bool
    );
    create table trials (
        profile_id int,
        gender varchar,
        gender_rec varchar,
        age int,
        country varchar,
        location_rec varchar,
        education varchar,
        education_rec int,
        no_foreign_lang int,
        best_foreign varchar,
        handedness varchar,
        handedness_rec int
    );
    create table sessions (
        exp_id int,
        date timestamp,
        profile_id int
    }
    """)

    import_csv(conn, "word_info", word_info_csv)
    import_csv(conn, "lexical", lexical_csv)
    import_csv(conn, "trials", trials_csv)
    import_csv(conn, "sessions", sessions_csv)


if __name__ == "__main__":
    main()