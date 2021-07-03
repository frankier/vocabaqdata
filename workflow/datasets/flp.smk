# URLs
cnf("FLP_URL", "https://osf.io/qpk9y/download")

# Intermediates
cnf("FLP_RAR", pjoin(WORK, "flp.rar"))
cnf("FLP_TSV_DIR"


rule download_flp:
    output:
        FLP_RAR
    shell:
        "wget -nv " + FLP_URL " -O {output}"


rule extract_flp:
    output:
