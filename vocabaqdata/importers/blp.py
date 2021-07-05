import click
import duckdb
from vocabaqdata.import_tools import import_tsv, setup_import


@click.command()
@click.argument("items_tsv", type=click.Path(exists=True))
@click.argument("pseudoword_syllables_tsv", type=click.Path(exists=True))
@click.argument("stimuli_tsv", type=click.Path(exists=True))
@click.argument("trials_tsv", type=click.Path(exists=True))
@click.argument("db_out", type=click.Path())
def main(items_tsv, pseudoword_syllables_tsv, stimuli_tsv, trials_tsv, db_out):
    conn = duckdb.connect(db_out)
    setup_import(conn)

    print("Creating tables")
    conn.execute("""
    create table items (
        spelling varchar,
        lexicality varchar,
        rt int,
        zscore float,
        accuracy float,
        rt_sd float,
        zscore_sd float,
        accuracy_sd float
    );
    create table stimuli (
        spelling varchar,
        coltheart_N int,
        OLD20 float,
        nletters int,
        nsyl int,
        morphology varchar,
        flection varchar,
        synclass varchar,
        celex_frequency int,
        celex_frequency_lemma int,
        celex_inflectional_entropy float,
        lemma_size int,
        nlemmas int,
        bnc_frequency int,
        bnc_frequency_million float,
        subtlex_frequency int,
        subtlex_frequency_million float,
        subtlex_cd int,
        subtlex_cd_pct float,
        summed_monogram int,
        summed_bigram int,
        summed_trigram int
    );
    create table trials (
        participant int,
        lexicality varchar,
        block int,
        environment varchar,
        order_num int,
        trial int,
        spelling varchar,
        button int,
        response varchar,
        accuracy bool,
        previous_accuracy bool,
        rt int,
        previous_rt int,
        microsec_error int,
        unix_seconds int,
        unix_microseconds int,
        trial_day int,
        trial_session int,
        order_in_block int,
        order_in_subblock int,
        rt_raw int
    );
    """)

    import_tsv(conn, "items", items_tsv, null="NA")
    import_tsv(conn, "stimuli", stimuli_tsv, null="NA")
    import_tsv(conn, "trials", trials_tsv, null="NA")


if __name__ == "__main__":
    main()
