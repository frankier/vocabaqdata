cnf("SVL12K_RAW", "/does/not/exist")
cnf("SVL12K_DF", pjoin(WORK, "ehara_svl12k.parquet"))
cnf("SVL12K_LIST", pjoin(WORK, "svl12k_wordlist.txt"))


rule all_svl12k:
    input:
        SVL12K_DF, SVL12K_DF
    output:
        touch(pjoin(WORK, ".svl12k_all"))


rule import_ehara_svl12k:
    input:
        SVL12K_RAW
    output:
        SVL12K_DF
    shell:
        "python -m vocabaqdata.importers.ehara_svl12k {input} {output}"


rule mk_ehara_svl12k_wordlist:
    input:
        SVL12K_DF
    output:
        SVL12K_LIST
    shell:
        "python -m vocabaqdata.proc.extract_wordlist_from_resps {input} {output}"
