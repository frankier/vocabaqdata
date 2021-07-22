from snakemake.shell import shell


shell(
    "python -m vocabaqdata.proc.lexdecis_to_inventory" +
    " --fmt " + snakemake.params["fmt"] + " " +
    snakemake.input[0] + " " + snakemake.output["df"]
)
shell(
    "python -m vocabaqdata.proc.add_zipfs " + snakemake.params["lang"] +
    " " + snakemake.output["df"] + " " + snakemake.output["df_enriched"]
)
