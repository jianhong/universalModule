nextflow.enable.dsl=2

if(!binding.hasVariable(library)){
  def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
    loadScriptByName("lib/loadmodule.groovy")
  }
  this.metaClass.mixin library
}

params.options = [:]
options = [publish_dir: 'bwa/mem',
           publish_mode: 'copy',
           publish_enabled: false,
           args: '-M',
           samtools_args: '-h -F 0x0100 -O BAM',
           suffix: '']

params.options.forEach{key, value -> options[key]=value}

include { BWA_MEM      } from loadModule('bwa_mem', 'master') addParams(options: [publish_dir: options.publish_dir,
                                                                                  publish_mode: options.publish_mode,
                                                                                  publish_enabled: options.publish_enabled,
                                                                                  args: options.args,
                                                                                  samtools_args: options.samtools_args,
                                                                                  suffix: options.suffix])
include { SAMTOOLS_SORT_INDEX } from loadModule('samtools_sort_index', 'master') addParams(options: [publish_dir: options.publish_dir,
                                                                                             publish_mode: options.publish_mode])
workflow MAP_BWA_MEM {
    take:
    ch_reads         // channel: [ val(meta), [ reads ] ]
    ch_index         //    path: [ [index], fasta ]

    main:
    BWA_MEM(ch_reads, ch_index)
    BAM_SORT_SAMTOOLS(BWA_MEM.out.bam)

    emit:
    bam = BAM_SORT_SAMTOOLS.out.bam                           // channel: [ val(meta), [ bam ], [ bai ] ]
    stats = BAM_SORT_SAMTOOLS.out.stats                       // channel: [ val(meta), [ stats ] ]
    flagstat = BAM_SORT_SAMTOOLS.out.flagstat                 // channel: [ val(meta), [ flagstat ] ]
    idxstats = BAM_SORT_SAMTOOLS.out.idxstats                 // channel: [ val(meta), [ idxstats ] ]
    bwa_version = BWA_MEM.out.version                         //    path: bwa.version.txt
    samtools_version = BAM_SORT_SAMTOOLS.out.samtools_version //    path: samtools.version.txt
}
