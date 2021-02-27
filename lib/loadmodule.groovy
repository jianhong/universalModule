class library {
  def loadModule(String module, String branch) {
    def remote = "https://raw.githubusercontent.com/jianhong/universalModule/${branch}/modules/"
    def ext    = "/main.nf"
    File file = File.createTempFile(module, '.nf');
      file.withOutputStream { out ->
        new URL(remote + module + ext).withInputStream{ from -> out << from; }
      }
      return file.getAbsolutePath().replaceFirst(/.nf$/, '')
  }
}
