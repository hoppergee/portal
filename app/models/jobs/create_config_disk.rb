class Jobs::CreateConfigDisk < Job
  def perform(args_json)
    args = JSON.parse(args_json)

    vm   = args['vm']['virtual_machine']

    if vm.nil?
      vm = args['vm']
    end

    return nil if vm['created_at'].nil?

    vm = VirtualMachine.find(vm['id'])

    opts = args['opts'] || {}

    account = vm.account
    job = super(account, args_json, opts)

    os = os_version = ''; arch = 'amd64'
    os, os_version, arch = vm.os_template.split('-')

    # Defaults
    opts[:flavor] = 'linux'

    case os
    when 'freebsd'
      opts[:flavor] = 'bsd'
    when 'openbsd'
      opts[:flavor] = 'bsd'
    end

    # Extract network info from VM object
    first_interface = vm.virtual_machines_interfaces[0]
    mac_address     = first_interface.mac_address
    ipv4_address    = first_interface.ip_address
    ipv4_gateway, ipv4_netmask = account.network_settings_for(ipv4_address)

    work = {
      class: 'CreateVolumeConfigDiskWorker',
      args:  [job.id, job.jid,
              vm.uuid,
              vm.label,
              mac_address,
              ipv4_address,
              ipv4_netmask,
              ipv4_gateway,
              opts
              ]
    }

    if Rails.env == 'development'
      queue = Socket.gethostname
    else
      queue = vm.abbreviated_host
    end

    ARP_REDIS.lpush("queue:#{queue}", work.to_json)

    job
  end
end
