# URLs
cnf("FLP_URL", "https://osf.io/qpk9y/download")
cnf("FLP_PSEUDOWORDS_URL", "https://osf.io/63yjn/download")
cnf("FLP_WORDS_URL", "https://osf.io/45wgy/download")


# Intermediates
cnf("FLP_RAR", pjoin(WORK, "flp.rar"))
cnf("FLP_PSEUDOWORDS", pjoin(WORK, "pseudowords.xls"))
cnf("FLP_WORDS", pjoin(WORK, "words.xls"))
cnf("FLP_TSV_DIR", pjoin(WORK, "flp"))
FLP_TSV = pjoin(FLP_TSV_DIR, "results.tt.txt")

# Outputs
cnf("FLP_DF", pjoin(WORK, "flp.parquet"))
cnf("FLP_PSEUDOWORDS_DF", pjoin(WORK, "flp.pseudowords.parquet"))
cnf("FLP_WORDS_DF", pjoin(WORK, "flp.words.parquet"))
cnf("FLP_DB", pjoin(WORK, "flp.duckdb"))


rule download_flp:
    output:
        rar = FLP_RAR,
        pseudowords = FLP_PSEUDOWORDS,
        words = FLP_WORDS
    shell:
        "wget -nv " + FLP_URL + " -O {output.rar}" + 
        " && wget -nv " + FLP_PSEUDOWORDS_URL + " -O {output.pseudowords}" + 
        " && wget -nv " + FLP_WORDS_URL + " -O {output.words}"


rule extract_flp:
    input:
        FLP_RAR
    output:
        FLP_TSV
    shell:
        "input=$(realpath {input})"
        " && mkdir -p " + FLP_TSV_DIR +
        " && cd " + FLP_TSV_DIR +
        " && unrar e -o+ $input"


rule import_flp_decisions:
    input:
        FLP_TSV,
    output:
        FLP_DF
    shell:
        "python -m vocabaqdata.importers.flp_decisions {input} {output}"


rule import_flp_psuedowords:
    input:
        FLP_PSEUDOWORDS
    output:
        FLP_PSEUDOWORDS_DF
    shell:
        "python -m vocabaqdata.importers.flp_words {input} {output}"


rule import_flp_words:
    input:
        FLP_WORDS
    output:
        FLP_WORDS_DF
    shell:
        "python -m vocabaqdata.importers.flp_words {input} {output}"


rule import_flp_db:
    input:
        decisions = FLP_DF,
        pseudowords = FLP_PSEUDOWORDS_DF,
        words = FLP_WORDS_DF
    output:
        FLP_DB
    shell:
        "python -m vocabaqdata.importers.flp" +
        " {input.decisions} {input.pseudowords}" +
        " {input.words} {output}"
