# URLS
cnf("EVKD1_TEST_QUESTIONS_PDF", "https://www.victoria.ac.nz/lals/about/staff/publications/paul-nation/VST-version-A.pdf")
cnf("EVKD1_TEST_ANSWERS_PDF", "https://www.victoria.ac.nz/lals/about/staff/publications/paul-nation/VST-version-A_answers.pdf")

# Inputs
cnf("EVKD1_RAW", "/does/not/exist")

# Intermediates
cnf("EVKD1_TEST_QUESTIONS", pjoin(WORK, "evkd1_test_questions.txt"))
cnf("EVKD1_TEST_ANSWERS", pjoin(WORK, "evkd1_test_answers.txt"))
cnf("EVKD1_TEST_ANSWERS_DF", pjoin(WORK, "evkd1_test_answers.parquet"))

# Output
cnf("EVKD1_RESP_DF", pjoin(WORK, "evkd1_resp.parquet"))


rule all_evkd1:
    input:
        EVKD1_RESP_DF
    output:
        touch(pjoin(WORK, ".svl12k_all"))


rule download_and_convert_evkd1_test_qa:
    output:
        EVKD1_TEST_QUESTIONS,
        EVKD1_TEST_ANSWERS
    shell:
        "wget -O " + EVKD1_TEST_QUESTIONS + ".pdf " + EVKD1_TEST_QUESTIONS_PDF + " && " +
        "wget -O " + EVKD1_TEST_ANSWERS + ".pdf " + EVKD1_TEST_ANSWERS_PDF + " && " +
        "java -jar " + TABULA_JAR +
        " " + EVKD1_TEST_QUESTIONS + ".pdf --pages all --stream > " +
        EVKD1_TEST_QUESTIONS + " && " +
        "java -jar " + TABULA_JAR +
        " " + EVKD1_TEST_ANSWERS + ".pdf --pages all --stream > " +
        EVKD1_TEST_ANSWERS


rule evkd1_convert_gold_answers:
    input:
        EVKD1_TEST_ANSWERS
    output:
        EVKD1_TEST_ANSWERS_DF
    shell:
        "python -m vocabaqdata.importers.evkd1_test_answers {input} {output}"


rule evkd1_process_responses:
    input:
        resp = EVKD1_RAW,
        gold = EVKD1_TEST_ANSWERS_DF
    output:
        EVKD1_RESP_DF
    shell:
        "python -m vocabaqdata.importers.evkd1 {input.resp} {input.gold} {output}"
