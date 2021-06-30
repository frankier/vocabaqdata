import click
import pandas


@click.command()
@click.argument("in_resp", type=click.File("r", encoding="SHIFT_JIS"))
@click.argument("in_gold", type=click.File("rb"))
@click.argument("outf", type=click.File("wb"))
def main(in_resp, in_gold, outf):
    resp_df = pandas.read_csv(in_resp)
    gold_df = pandas.read_parquet(in_gold)
    resp_df.drop(
        columns=[
            "TOEICyear",
            "TOEICmonth",
            "TOEICscore",
            "TOEIClisteningscore",
            "TOEICreadingscore",
        ],
        inplace=True,
    )
    resp_df.reset_index(level=0, inplace=True)
    resp_df.rename(columns={"index": "resp_id"}, inplace=True)
    long_resp_df = pandas.melt(
        resp_df, id_vars=["resp_id"], var_name="word_num", value_name="resp"
    )
    long_resp_df["word_num"] = long_resp_df["word_num"].transform(
        lambda val: int(val[1:])
    )
    merged = long_resp_df.merge(gold_df, left_on="word_num", right_on="num")
    long_resp_df["correct"] = merged["resp"] == merged["answer"]
    long_resp_df["word"] = merged["word"]
    long_resp_df.to_parquet(outf)


if __name__ == "__main__":
    main()
