# encoding: utf-8

module Imap::Backup::Configuration
  class List
    attr_reader :accounts

    def initialize(accounts = nil)
      if not Imap::Backup::Configuration::Store.exist?
        raise Imap::Backup::ConfigurationNotFound.new("Configuration file '#{Imap::Backup::Configuration::Store.default_pathname}' not found")
      end
      @config = Imap::Backup::Configuration::Store.new

      if accounts.nil?
        @accounts = @config.data[:accounts]
      else
        @accounts = @config.data[:accounts].select{ |account| accounts.include?(account[:username]) }
      end
    end

    def each_connection
      @accounts.each do |account|
        connection = Imap::Backup::Account::Connection.new(account)
        yield connection
        connection.disconnect
      end
    end
  end
end
