# Intermediates
cnf("ELP_CSV_DIR", pjoin(WORK, "elp"))
ELP_CSV = pjoin(ELP_CSV_DIR, "elp.csv")

# Outputs
cnf("ELP_DF", pjoin(WORK, "elp.parquet"))

rule download_and_export_elp:
    output:
        ELP_CSV 
    params:
        r_script = srcdir("../../submodules/read-elp/trial-level-ldt.R")
    shell:
        "mkdir -p " + ELP_CSV_DIR
        + " && cd " + ELP_CSV_DIR
        + " && Rscript {params.r_script}"


rule import_elp:
    input:
        ELP_CSV
    output:
        ELP_DF
    shell:
        "python -m vocabaqdata.importers.elp {input} {output}"
