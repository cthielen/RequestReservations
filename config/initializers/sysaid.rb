# Initializes SysAid based on settings in config/sysaid.yml
begin
  sysaid_settings = YAML.load_file("#{Rails.root.to_s}/config/sysaid.yml")['sysaid']

  SysAid.server_settings = {
    :endpoint => sysaid_settings['endpoint'],
    :account => sysaid_settings['account'],
    :username => sysaid_settings['username'],
    :password => sysaid_settings['password']
  }

  SYSAID_SUPPORT = true

  SYSAID_STATUS_NEW = 1
  SYSAID_STATUS_CLOSED = 3
  SYSAID_ASSIGN_TO = sysaid_settings['assignTo']
rescue Errno::ENOENT => e
  Rails.logger.warn "config/sysaid.yml is missing. Disabling SysAid support."
  SYSAID_SUPPORT = false
end
