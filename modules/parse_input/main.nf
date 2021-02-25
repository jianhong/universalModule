params.options = [:]
process PARSE_INPUT {
  tag "$meta.id"

  output: ch_fastq, emit: fastq
  script:
  ch_input = Channel.fromPath(params.options.input)
  ch_input.splitCsv(header: true)
    .map{ row ->
        fq1 = row.remove("fastq_1")
        fq2 = row.remove("fastq_2")
        def meta = row.clone()
        meta.id = row.group + "_R" + row.replicate
        meta.single_end = fq2 == ""
        [meta, [fq1, fq2]]}
    .set{ch_fastq}
}
