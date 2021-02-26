#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.input = "https://raw.githubusercontent.com/jianhong/universalModule/master/modules/md_html/readme.md"
params.outdir = "."

md = Channel.fromPath(params.input)

def download(String module, String branch) {
  remote = "https://raw.githubusercontent.com/jianhong/universalModule/${branch}/modules/"
  ext    = "/main.nf"
  File file = File.createTempFile(module, '.nf');
    file.withOutputStream { out ->
      new URL(remote + module + ext).withInputStream{ from -> out << from; }
    }
    return file.getAbsolutePath().replaceFirst(/.nf$/, '')
}

module_file = download('md_html', 'master')
include { MD_HTML } from "${module_file}"

workflow TEST_MD2HTML {
  MD_HTML(md)
}
