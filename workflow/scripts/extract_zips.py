from snakemake.shell import shell


shell(
    "input=$(realpath " + snakemake.input[0] + ")" +
    " && mkdir -p " + snakemake.output[0] +
    " && cd " + snakemake.output[0] +
    " && unzip -o $input/\\*.zip"
)
