nextflow.enable.dsl=2

if(!binding.hasVariable(library)){
  def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
    loadScriptByName("lib/loadmodule.groovy")
  }
  this.metaClass.mixin library
}

params.options = [:]
options = [publish_dir: 'sort',
           publish_mode: 'copy',
           publish_enabled: true,
           args: '',
           suffix: ".sorted"]

params.options.forEach{key, value -> options[key]=value}

include { SAMTOOLS_SORT      } from loadModule('samtools_sort', 'master') addParams(options: [publish_dir: options.publish_dir,
                                                                                              publish_mode: options.publish_mode,
                                                                                              publish_enabled: options.publish_enabled,
                                                                                              args: options.args,
                                                                                              suffix: options.suffix])
include { SAMTOOLS_INDEX     } from loadModule('samtools_index', 'master') addParams(options: [publish_dir: options.publish_dir,
                                                                                              publish_mode: options.publish_mode,
                                                                                              publish_enabled: options.publish_enabled])
include { SAMTOOLS_STATS     } from loadModule('samtools_stats', 'master') addParams(options: [publish_dir: options.publish_dir,
                                                                                              publish_mode: options.publish_mode,
                                                                                              publish_enabled: options.publish_enabled])

 workflow SAMTOOLS_SORT_INDEX {
     take:
     ch_bam // val(meta), path(bam)

     main:
      SAMTOOLS_SORT(ch_bam)
      SAMTOOLS_INDEX(SAMTOOLS_SORT.out.bam)
      SAMTOOLS_STATS(SAMTOOLS_INDEX.out.bai)

    emit:
      bam = SAMTOOLS_SORT.out.bai                  // channel: [ val(meta), [ bam ], [ bai ] ]
      stats = BAM_STATS_SAMTOOLS.out.stats         // channel: [ val(meta), [ stats ] ]
      flagstat = BAM_STATS_SAMTOOLS.out.flagstat   // channel: [ val(meta), [ flagstat ] ]
      idxstats = BAM_STATS_SAMTOOLS.out.idxstats   // channel: [ val(meta), [ idxstats ] ]
      samtools_version = SAMTOOLS_SORT.out.version //    path: samtools.version.txt
 }
