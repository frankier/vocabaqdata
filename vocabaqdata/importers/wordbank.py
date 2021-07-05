import click
import pandas
import sqlalchemy
import duckdb
from vocabaqdata.import_tools import setup_import


CONN_STRING = "mysql://wordbank:wordbank@server.wordbank.stanford.edu/wordbank"


@click.command()
@click.argument("dbout")
def main(dbout):
    ddb = duckdb.connect(dbout)
    mysql_engine = sqlalchemy.create_engine(CONN_STRING)
    setup_import(ddb)

    cur = mysql_engine.execute("SHOW TABLES")
    tables = []
    for row in cur.fetchall():
        tables.append(row[0])
    print("Got tables", "; ".join(tables))

    for idx, table in enumerate(tables):
        prog = f"({idx + 1}/{len(tables)})"
        if table.startswith("auth_") or table.startswith("django_"):
            print(f"Skipping {table} {prog}")
            continue
        print(f"Importing {table} {prog}")
        df = pandas.read_sql_table(table, mysql_engine)  # noqa: usage in execute
        ddb.execute(f"CREATE TABLE {table} AS SELECT * FROM df")
        print()


if __name__ == "__main__":
    main()
