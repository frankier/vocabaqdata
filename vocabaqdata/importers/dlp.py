import click
import duckdb
from vocabaqdata.import_tools import import_tsv, setup_import


@click.command()
@click.argument("items_tsv", type=click.Path(exists=True))
@click.argument("stimuli_tsv", type=click.Path(exists=True))
@click.argument("trials_tsv", type=click.Path(exists=True))
@click.argument("db_out", type=click.Path())
def main(items_tsv, stimuli_tsv, trials_tsv, db_out):
    conn = duckdb.connect(db_out)
    setup_import(conn)

    print("Creating tables")
    conn.execute("""
    create table items (
        spelling varchar,
        lexicality varchar,
        rt float,
        zscore float,
        accuracy float,
        rt_sd float,
        zscore_sd float,
        accuracy_sd float,
        sub50_rt float,
        sub50_zscore float,
        sub50_accuracy float,
        sub50_rt_sd float,
        sub50_zscore_sd float,
        sub50_accuracy_sd float
    );
    create table stimuli (
        spelling varchar,
        coltheart_N int,
        OLD20 float,
        celex_frequency int,
        celex_cd int,
        celex_frequency_lemma int,
        subtlex_frequency int,
        subtlex_cd int,
        subtlex_frequency_lemma int,
        subtlex_frequency_million float,
        subtlex_log10_frequency float,
        subtlex_cd_percentage float,
        subtlex_log10_cd float,
        subtlex_dominant_pos varchar,
        subtlex_dominant_pos_frequency int,
        subtlex_dominant_pos_lemma varchar,
        subtlex_dominant_pos_lemma_frequency int,
        /* varchar array */
        subtlex_all_pos varchar,
        /* int array */
        subtlex_all_pos_frequency varchar,
        /* int array */
        subtlex_all_pos_lemma_frequency varchar,
        summed_monogram int,
        summed_bigram int,
        summed_trigram int,
        stress int,
        nchar int,
        nsyl int,
        celex_morphology varchar,
        celex_flection varchar,
        celex_synclass varchar
    );
    create table trials (
        environment varchar,
        participant int,
        block int,
        trial_order int,
        trial int,
        spelling varchar,
        lexicality varchar,
        response varchar,
        accuracy bool,
        previous_accuracy bool,
        rt int,
        zscore float,
        rt_raw int,
        previous_rt int,
        microsec_error int,
        unix_seconds int,
        unix_microseconds int,
        trial_day int,
        trial_session int,
        order_in_block int,
        order_in_subblock int
    );
    """)

    import_tsv(conn, "items", items_tsv, null="NA")
    import_tsv(conn, "stimuli", stimuli_tsv, null="NA")
    import_tsv(conn, "trials", trials_tsv, null="NA")


if __name__ == "__main__":
    main()
