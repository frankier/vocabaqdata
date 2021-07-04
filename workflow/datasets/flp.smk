# URLs
cnf("FLP_URL", "https://osf.io/qpk9y/download")

# Intermediates
cnf("FLP_RAR", pjoin(WORK, "flp.rar"))
cnf("FLP_TSV_DIR", pjoin(WORK, "flp"))
FLP_TSV = pjoin(FLP_TSV_DIR, "results.tt.txt")

# Outputs
cnf("FLP_DF", pjoin(WORK, "flp.parquet"))


rule download_flp:
    output:
        FLP_RAR
    shell:
        "wget -nv " + FLP_URL " -O {output}"


rule extract_flp:
    input:
        FLP_RAR
    output:
        FLP_TSV
    shell:
        "mkdir -p " + FLP_TSV_DIR +
        " && cd " + FLP_TSV_DIR +
        " && unrar e {input}"


rule import_flp:
    input:
        FLP_TSV
    output:
        FLP_DF
    shell:
        "python -m vocabaqdata.importers.flp {input} {output}"
