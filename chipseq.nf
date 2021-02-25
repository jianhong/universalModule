/*
 * There are three steps to use the remote module
 * 1. write download module function
 * 2. the module must be one file module
 * 3. load it outside of workflow or process
 */
params.options = [:]

def download(String module, String branch) {
  remote = "https://raw.githubusercontent.com/jianhong/universalModule/${branch}/modules/"
  ext    = "/main.nf"
  File file = File.createTempFile(module, '.nf');
    file.withOutputStream { out ->
      new URL(remote + module + ext).withInputStream{ from -> out << from; }
    }
    return file.getAbsolutePath().replaceFirst(/.nf$/, '')
}

checksum_file = download('checksum', 'master')
include { CHECKSUM } from "${checksum_file}" addParams(options: [publish_dir: "md5"])

workflow CHIPSEQ {
  main:

  Channel.fromPath(params.input)
         .splitCsv(header: true)
         .map{ row ->
            fq1 = row.remove("fastq_1")
            fq2 = row.remove("fastq_2")
            def meta = row.clone()
            meta.id = row.group + "_R" + row.replicate
            meta.single_end = fq2 == ""
            [meta, [fq1, fq2]]}
         .set{ch_fastq}

  CHECKSUM(ch_fastq)
}
