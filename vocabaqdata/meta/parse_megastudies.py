from bs4 import BeautifulSoup
import click


@click.command()
@click.argument("inf", type=click.File("r"))
def main(inf):
    """
    Parse HTML fetched from http://crr.ugent.be/programs-data/megastudy-data-available
    """
    doc = BeautifulSoup(inf.read(), "lxml")
    content = doc.find_all("div", class_="post-content")[0]
    elem = content.select("p > strong")[0].parent
    lang = None
    print("shortref\tlang\ttype\tmode\thas_l2\tnum_words\tmainlink\totherlinks")
    while elem:
        if elem.name == "p" and elem.contents[0].name == "strong":
            lang = elem.contents[0].contents[0].strip()
        elif elem.name == "ul":
            studies = elem.find_all("li", recursive=False)
            for study in studies:
                mainlink = study.find("a", recursive=False)
                item_list = study.find("ul", recursive=False)
                has_l2 = "l2" in item_list.get_text().lower()
                items = item_list.find_all("li", recursive=False)
                other_links = [
                    other_link["href"]
                    for other_link in item_list.find_all("a")
                ]
                if mainlink:
                    shortref = mainlink.get_text().strip()
                    main_href = mainlink["href"]
                else:
                    shortref = study.contents[0].strip()
                    main_href = ""
                type = items[0].contents[0]
                lower_type = type.lower()
                if (
                    "lexical decision" in lower_type or
                    "word recognition" in lower_type
                ):
                    type = "Lexical decision"
                elif "reading" in lower_type or "eye" in lower_type:
                    type = "Eye tracking"
                elif "naming" in lower_type:
                    type = "Naming"
                mode = items[1].contents[0].strip()
                if "presentation" not in mode.lower():
                    mode = ""
                num_words = ""
                for item in (items[-2], items[-1]):
                    cand_num_words = item.contents[0].strip()
                    cand_num_words_lower = num_words.lower()
                    if "word" in cand_num_words_lower or "character" in cand_num_words_lower:
                        num_words = cand_num_words
                        break
                print(
                    "\t".join([
                        shortref,
                        lang,
                        type,
                        mode,
                        "yes" if has_l2 else "no",
                        num_words,
                        main_href,
                        " ; ".join(other_links)
                    ])
                )
        elem = elem.next_sibling


if __name__ == "__main__":
    main()
