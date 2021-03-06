# encoding: utf-8
require 'spec_helper'

describe Imap::Backup::Downloader do
  context 'with account and downloader' do
    let(:local_path) { '/base/path' }
    let(:stat) { stub('File::Stat', :mode => 0700) }
    let(:message) do
      {
        'RFC822' => 'the body',
        'other'  => 'xxx'
      }
    end
    let(:folder) { stub('Imap::Backup::Account::Folder', :fetch => message) }
    let(:serializer) do
      stub(
        'Imap::Backup::Serializer',
        :prepare => nil,
        :exist?  => true,
        :uids    => [],
        :save    => nil
      )
    end

    before { File.stub!(:stat).with(local_path).and_return(stat) }

    subject { Imap::Backup::Downloader.new(folder, serializer) }

    context '#run' do
      context 'with folder' do
        it 'should list messages' do
          folder.should_receive(:uids).and_return([])

          subject.run
        end

        context 'with messages' do
          before :each do
            folder.stub!(:uids).and_return(['123', '999', '1234'])
          end

          it 'should skip messages that are downloaded' do
            File.stub!(:exist?).and_return(true)

            serializer.should_not_receive(:fetch)

            subject.run
          end

          it 'skips failed fetches' do
            folder.should_receive(:fetch).with('999').and_return(nil)
            serializer.should_not_receive(:save).with('999', anything)

            subject.run
          end

          context 'to download' do
            before :each do
              serializer.stub!(:exist?) do |uid|
                if uid == '123'
                  true
                else
                  false
                end
              end
            end

            it 'should request messages' do
              folder.should_receive(:fetch).with('999')
              folder.should_receive(:fetch).with('1234')

              subject.run
            end

            it 'should save messages' do
              serializer.should_receive(:save).with('999', message)
              serializer.should_receive(:save).with('1234', message)

              subject.run
            end
          end
        end
      end
    end
  end
end
