from vocabaqdata.import_tools import mk_import_command


main = mk_import_command(
    filetype="tsv",
    encoding="iso-8859-1",
    names=["exp_id", "item_id", "spelling", "rt", "accuracy", "lexicality"]
)


if __name__ == "__main__":
    main()
