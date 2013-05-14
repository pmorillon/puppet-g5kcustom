Puppet::Type.newtype(:ssh_user_config) do
  @doc = 'Manage user ssh config file'

  ensurable do
    newvalue(:present) do
      provider.add
    end

    newvalue(:absent) do
      provider.remove
    end
  end

  newparam(:name) do
    desc 'The uniq name of the resource'
    isnamevar
  end

  newparam(:user) do
    desc 'Configure ssh config file for this user'

    defaultto ENV['USER'] || 'root'
  end

  newparam(:host) do
    desc 'Host value'

    validate do |value|
      raise ArgumentError, "host Parameter must be not null" if value.match(/^\s*$/)
    end
  end

  newproperty(:config) do
    desc 'Host configuration as a hash'
  end

  validate do
    raise Puppet::Error, "You must specify a host Parameter for ssh_user_config Type" unless @parameters.include?(:host)
  end

end
