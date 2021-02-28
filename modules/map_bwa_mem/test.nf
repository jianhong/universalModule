#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

params.input = 'https://raw.githubusercontent.com/nf-core/test-datasets/atacseq/reference/genome.fa'
params.fastq = 'https://raw.githubusercontent.com/nf-core/test-datasets/atacseq/testdata/SRR1822153_1.fastq.gz'
params.outdir = "."

fasta = Channel.fromPath(params.input)
fastq = Channel.fromPath(params.fastq)

include { MAP_BWA_MEM } from loadModule('map_bwa_mem', 'master')

workflow TEST_MAP_BWA_MEM {
  BWA_INDEX(fasta)
  MAP_BWA_MEM(fastq, BWA_INDEX.out.index)
}
