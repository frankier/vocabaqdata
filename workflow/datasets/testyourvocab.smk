rule import_testyourvocab_nonnative:
    input:
        users = pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "users_nonnative.tsv"),
        answers = pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "users_nonnative_answers.tsv"),
        ranks = pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "ranks.tsv"),
    output:
        TESTYOURVOCAB_NONNATIVE_DB
    shell:
        "bash ./vocabaqdata/importers/testyourvocab_nonnative.sh {input.users} {input.answers} {input.ranks} {output}"
