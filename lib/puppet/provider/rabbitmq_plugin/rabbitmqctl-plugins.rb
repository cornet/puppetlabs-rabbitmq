Puppet::Type.type(:rabbitmq_plugin).provide(:rabbitmqplugin) do

  commands :rabbitmqplugin => 'rabbitmq-plugins'
  defaultfor :feature => :posix

  def self.instances
    rabbitmqplugin('list').split(/\n/).map do |line|
      if line =~ /^\[[a-zA-Z]\] (\S+)\s.*$/
        new(:name => $1)
      else
        raise Puppet::Error, "Cannot parse invalid plugin line: #{line}"
      end
    end
  end

  def create
    rabbitmqplugin('enable', resource[:name])
  end

  def destroy
    rabbitmqplugin('disable', resource[:name])
  end

  def exists?
    out = rabbitmqplugin("list", resource[:name]).split(/\n/).detect do |line|
      line.match(/^\[E\] #{resource[:name]}\s.*$/)
    end
  end

end
