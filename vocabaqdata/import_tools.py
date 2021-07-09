from functools import partial


def setup_import(conn):
    conn.execute("""
    PRAGMA memory_limit='4GB';
    PRAGMA threads=8;
    PRAGMA set_progress_bar_time=1;
    """)


def import_tsv(
    conn,
    tbl_name,
    path,
    no_header=False,
    null="NULL",
    delimiter="\t",
    quote="",
):
    header = "0" if no_header else "1"
    print(f"Importing {tbl_name}")
    conn.execute(f"""
    COPY {tbl_name} FROM '{path}'
    ( DELIMETER '{delimiter}', QUOTE '{quote}', NULL '{null}', HEADER {header} );
    """)


import_csv = partial(import_tsv, delimiter=",")


def mk_import_command(filetype="csv", **kwargs):
    import click
    import pandas
    from pandas.api.extensions import no_default

    sep = no_default
    if filetype == "tsv":
        sep = "\t"

    @click.command()
    @click.argument("inf")
    @click.argument("parquet_out")
    def main(inf, parquet_out):
        df = pandas.read_csv(inf, sep=sep, **kwargs)
        df.to_parquet(parquet_out)

    return main
