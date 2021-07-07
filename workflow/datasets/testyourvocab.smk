# Inputs
cnf("TESTYOURVOCAB_RANKS", "/does/not/exist")
cnf("TESTYOURVOCAB_NATIVE_RAW", "/does/not/exist")
cnf("TESTYOURVOCAB_NONNATIVE_RAW", "/does/not/exist")

# Outputs
cnf("TESTYOURVOCAB_DB", pjoin(WORK, "testyourvocab.duckdb"))


rule import_testyourvocab:
    input:
        ranks = TESTYOURVOCAB_RANKS,
        nonnative_users = pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "users_nonnative.tsv"),
        nonnative_answers = pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "users_nonnative_answers.tsv"),
        native_users = pjoin(TESTYOURVOCAB_NATIVE_RAW, "users_native.tsv"),
        native_answers = pjoin(TESTYOURVOCAB_NATIVE_RAW, "users_native_answers.tsv"),
    output:
        unique_nonnative_answers = temp(pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "users_nonnative_answers.unique.tsv")),
        unique_native_answers = temp(pjoin(TESTYOURVOCAB_NATIVE_RAW, "users_native_answers.unique.tsv")),
        db = TESTYOURVOCAB_DB
    shell:
        "python -m vocabaqdata.importers.testyourvocab_key {input.ranks} {output.db}" +
        " && tail +2 {input.nonnative_answers}" +
        "    | sort -k1n -k2n -u --buffer-size=8G -" + 
        "    > {output.unique_nonnative_answers}"
        " && tail +2 {input.native_answers} " + 
        "    | sort -k1n -k2n -u --buffer-size=8G - " +
        "    > {output.unique_native_answers}" +
        " && python -m vocabaqdata.importers.testyourvocab_nonnative" +
        "    {input.nonnative_users} {output.unique_nonnative_answers} {output.db}" +
        " && python -m vocabaqdata.importers.testyourvocab_native " +
        "    {input.native_users} {output.unique_native_answers} {output.db}"
