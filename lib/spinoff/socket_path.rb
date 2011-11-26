require 'tempfile'
require 'digest/md5'

module Spinoff
  def self.socket_path
    File.join(Dir.tmpdir, [Digest::MD5.hexdigest(Dir.pwd), 'spinoff'].join('.'))
  end
end
