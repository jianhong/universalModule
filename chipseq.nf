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

checksum_file = download('checksum')
include { CHECKSUM } from "${checksum_file}" addParams(options: [publish_dir: "checksum"])
parse_input_file = download('parse_input')
include { PARSE_INPUT } from "${parse_input_file}" addParams(options: [input: params.input])

workflow CHIPSEQ {
  main:
  PARSE_INPUT() | CHECKSUM
}
