$:.unshift(File.dirname(__FILE__))

require 'starling'
require 'rconfig'
require 'fileutils'

class CopyPasteError < StandardError; end
class CopyPaste
  VERSION = "0.9.1"
  CONFIGURATION = "#{ENV['HOME']}/.copypaste"
  
  class << self
    def copy(queue, io)
      queue ||= "default"
      server
      data = io.read
      server.set("copypaste-#{queue}", data)
      data
    end
    
    def paste(queue)
      queue ||= "default"
      server.get("copypaste-#{queue}")
    end
    
    def setup(value)
      if value.to_s.empty?
        print "What is your starling server address (127.0.0.1:22122): "
        $stdout.flush
        server = gets.strip
      else
        server = value
      end
      
      if server.empty?
        server = "127.0.0.1:22122"
      end
      if !server.include?(":")
        server = "#{server}:22122"
      end
      
      File.open("#{CONFIGURATION}/config.yml", "w"){|f| f << {"server" => server}.to_yaml }
      puts "\nSaved to #{CONFIGURATION}/config.yml"
    end
    
    def server
      if RConfig.config == {}
        puts "Please run #{$0} --setup"
        exit -1
      else
        @@server = Starling.new(RConfig.config.server)
      end
    end
  end
end

FileUtils.mkdir_p(CopyPaste::CONFIGURATION)
RConfig.config_paths = [CopyPaste::CONFIGURATION, "/etc/copypaste"]
