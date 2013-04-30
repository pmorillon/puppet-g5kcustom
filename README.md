# Custom Puppet module

This Puppet module is used on the [Grid'5000](https://www.grid5000.fr) infrastructure.

# Types

## SSH

### Client

#### ssh_user_config

Manage users ssh client config file by host : `$USER/.ssh/config`

    $myuser = 'jdoe'

    file {
      "/home/${myuser}/.ssh/config":
        ensure  => file,
        mode    => '0644',
        owner   => $myuser,
        group   => $myuser;
    }

    ssh_user_config {
      'jdoe github.com':
        ensure  => present,
        user    => $myuser,
        host    => 'github.com',
        config  => {
          'StrictHostKeyChecking' => 'no',
          'HashKnownHosts'        => 'no',
          'SendENV'               => 'ADM_USER'
        },
        require => File["/home/${myuser}/.ssh/config"];
    }


