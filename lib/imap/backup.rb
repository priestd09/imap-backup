require 'imap/backup/utils'
require 'imap/backup/account/connection'
require 'imap/backup/account/folder'
require 'imap/backup/configuration/account'
require 'imap/backup/configuration/asker'
require 'imap/backup/configuration/connection_tester'
require 'imap/backup/configuration/folder_chooser'
require 'imap/backup/configuration/list'
require 'imap/backup/configuration/setup'
require 'imap/backup/configuration/store'
require 'imap/backup/downloader'
require 'imap/backup/serializer/base'
require 'imap/backup/serializer/directory'
require 'imap/backup/serializer/mbox'
require 'imap/backup/version'

require 'logger'

module Imap::Backup
  class ConfigurationNotFound < StandardError; end

  class Logger
    include Singleton

    attr_reader :logger

    def initialize
      @logger = ::Logger.new(STDOUT)
    end
  end

  def self.logger
    Imap::Backup::Logger.instance.logger
  end
end
