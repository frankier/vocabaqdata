import click


@click.command()
@click.argument("freqs")
@click.argument("words", type=click.File("r"))
@click.argument("outf", type=click.File("w"))
def main(freqs, words, outf):
    outf.write("lemma,freq\n")
    with open(freqs, "r", errors="ignore") as freqs_f:
        word_set = {word.strip() for word in words}
        next(freqs_f)
        for pair in freqs_f:
            lemma, freq = pair.rsplit(",", 1)
            if lemma in word_set:
                outf.write(f"{lemma},{freq}")


if __name__ == "__main__":
    main()
