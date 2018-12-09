@config = YAML.load(File.read(File.join(File.dirname(__FILE__), '..', '..', 'config', 'arp', 'globals.yml')))

if conf = @config[Rails.env]
  # CD-ROM ISOs
  $ISO_BASE = conf['iso_base']

  # To disable online payments
  $PAYMENT_SYSTEM_DISABLED_LOCKFILE = conf['payment_system_disabled_lockfile']

  $ADMINS = conf['admins']['portal']
  $ADMINS_CONSOLE = conf['admins']['console']
  $IRR_PASSWORD = conf['irr_password']

  $HOST_RANCID      = conf['hosts']['rancid']
  $HOST_RANCID_USER = conf['hosts']['rancid_user']
  $HOST_RANCID_DIR  = conf['hosts']['rancid_dir']
  $HOST_RANCID_PROVISION_VLAN_SCRIPT = conf['hosts']['rancid_provision_vlan_script']
  $HOST_CONSOLE     = conf['hosts']['console']
  $HOST_CACTI       = conf['hosts']['cacti']
  $HOST_CACTI_DIR   = conf['hosts']['cacti_dir']
  $HOST_PORTAL      = conf['hosts']['portal']

  $VLAN_MIN = conf['vlan_min']

  $KEYER    = conf['keyer']

  $SIMPLE_CRYPT_KEY = conf['simple_crypt_key']
  $OTP_PREFIX       = conf['otp_prefix']

  $PORTS_MIN_VNC    = conf['ports']['min']['vnc']
  $PORTS_MIN_WS     = conf['ports']['min']['web_socket']
  $PORTS_MIN_SERIAL = conf['ports']['min']['serial']

  $SLACK_WEBHOOK_URL = conf['slack']['webhook_url']

  $ARIN_API_KEY     = conf['arin']['api_key']

  $PROVISIONING     = conf['provisioning']

  $JOBS_QUEUE_HEALTH_EXCLUSIONS = conf['jobs']['queue_health_exclusions']
end
