import click
import pandas


@click.command()
@click.argument("readme", type=click.File("r+"), default="README.md")
@click.argument(
    "table",
    type=click.File("r"),
    default="vocabaqdata/datasets.tsv"
)
def main(readme, table):
    lines = readme.read().split("\n")
    start_idx = end_idx = None
    for idx, line in enumerate(lines):
        if "# (START_TABLE)" in line:
            start_idx = idx + 1
        if "# (END_TABLE)" in line:
            end_idx = idx
    if start_idx is None or end_idx is None:
        raise click.ClickException("Could not find table markers. Aborting!")
    df = pandas.read_csv(table, sep="\t")
    lines[start_idx:end_idx] = [""] + df.to_markdown(index=False).strip().split("\n") + [""]
    readme.truncate()
    readme.seek(0)
    readme.write("\n".join(lines))


if __name__ == "__main__":
    main()
