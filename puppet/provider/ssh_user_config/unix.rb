Puppet::Type.type(:ssh_user_config).provide(:unix) do

  desc 'Configure users ssh config files for Unix system'

  defaultfor :kernel => :linux
  defaultfor :kernel => :darwin

  attr_accessor :hosts

  def parsefile
    host = {}
    filepath = File.expand_path("~#{resource[:user]}/.ssh/config")
    raise Puppet::Error, "File #{filepath} does not exist" unless File.exists? filepath
    File.open(filepath, 'r') do |file|
      while line = file.gets
        case line
        when /^\s*[Hh]ost (.*)$/
          host = { 'host' => $1, 'config' => {} }
          @hosts << host
          next
        when /^\s*$/
          # Ignore empty lines
          next
        when /^\s*#/
          # Ignore comments
          next
        when /^\s*(\w+)\s*(.*)$/
          host['config'][$1] = $2
        end
      end
    end
  end

  def writefile
    filepath = File.expand_path("~#{resource[:user]}/.ssh/config")
    File.open(filepath, 'w') do |file|
      file.puts '# File managed by Puppet, do not edit manually !'
      file.puts "# Last modification : #{Time.now}\n\n"
      @hosts.each do |host|
        file.puts "Host #{host['host']}"
        host['config'].each do |key, value|
          file.puts "  #{key} #{value}"
        end
        file.puts ""
      end
    end
  end

  def exists?
    @hosts ||= []
    parsefile
    @hosts.select { |x| x['host'] == resource[:host] }.length == 1
  end

  def add
    @hosts << { 'host' => resource[:host], 'config' => resource[:config] }
    writefile
  end

  def remove
    host2change = @hosts.select { |x| x['host'] == resource[:host] }.first
    @hosts.delete host2change
    writefile
  end

  def config
    conf = @hosts.select { |x| x['host'] == resource[:host] }.first['config']
    conf
  end

  def config=(host_config)
    host2change = @hosts.select { |x| x['host'] == resource[:host] }.first
    @hosts.delete host2change
    @hosts << { 'host' => resource[:host], 'config' => resource[:config] }
    writefile
  end

end
