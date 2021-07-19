from snakemake.shell import shell


shell("mkdir -p " + snakemake.output[0])
for url in snakemake.params.urls:
    shell("cd " + snakemake.output[0] + " && wget -nv " + url)
