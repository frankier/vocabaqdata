# Inputs
cnf("TESTYOURVOCAB_RANKS", "/does/not/exist")
cnf("TESTYOURVOCAB_NATIVE_RAW", "/does/not/exist")
cnf("TESTYOURVOCAB_NONNATIVE_RAW", "/does/not/exist")

# Outputs
cnf("TESTYOURVOCAB_DB", pjoin(WORK, "testyourvocab.db"))


rule import_testyourvocab_key:
    input:
        TESTYOURVOCAB_RANKS
    output:
        touch(pjoin(WORK, ".testyourvocab.key.imported"))
    shell:
        "python -m vocabaqdata.importers.testyourvocab_nonnative {input} " + TESTYOURVOCAB_DB


rule filter_unique_answers:
    input:
        pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "users_nonnative_answers.tsv")
    output:
        temp(pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "users_nonnative_answers_unique.tsv"))
    shell:
        "tail +2 {input} | sort -k1n -k2n -u --buffer-size=30% - > {output}"


rule import_testyourvocab_nonnative:
    input:
        users = pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "users_nonnative.tsv"),
        answers = pjoin(TESTYOURVOCAB_NONNATIVE_RAW, "users_nonnative_answers_unique.tsv"),
        keys = import_testyourvocab_key.output
    output:
        touch(pjoin(WORK, ".testyourvocab.nonnative.imported"))
    shell:
        "python -m vocabaqdata.importers.testyourvocab_nonnative {input.users} {input.answers} " + TESTYOURVOCAB_DB


rule import_testyourvocab_native:
    input:
        users = pjoin(TESTYOURVOCAB_NATIVE_RAW, "users_native.tsv"),
        answers = pjoin(TESTYOURVOCAB_NATIVE_RAW, "users_native_answers_unique.tsv"),
        keys = import_testyourvocab_key.output,
        force_serialise = import_testyourvocab_nonnative.output
    output:
        touch(pjoin(WORK, ".testyourvocab.native.imported"))
    shell:
        "python -m vocabaqdata.importers.testyourvocab_native {input.users} {input.answers} " + TESTYOURVOCAB_DB


rule import_testyourvocab_all:
    input:
        import_testyourvocab_nonnative.output,
        import_testyourvocab_native.output
    output:
        TESTYOURVOCAB_DB
