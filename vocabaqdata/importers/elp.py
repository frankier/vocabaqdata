from vocabaqdata.import_tools import mk_import_command


def create_view(conn):
    conn.execute("""
    create view decision_view as
    select
        Subject_ID as participant,
        case
            when Lexicality = 1 then 'W'
            else 'N'
        end as lexicality,
        case
            when Lexicality = 1 AND Accuracy = 1 then 'W'
            when Lexicality = 0 AND Accuracy = 1 then 'N'
            when Lexicality = 1 AND Accuracy = 0 then 'N'
            else 'W'
        end as response,
        Accuracy as accuracy,
        Item as spelling
    from
        decisions;
    """)


main = mk_import_command("csv", keep_default_na=False)


if __name__ == "__main__":
    main()
