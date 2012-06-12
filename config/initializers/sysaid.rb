# Initializes SysAid based on settings in config/sysaid.yml
SYSAID_SUPPORT = false

begin
  sysaid_settings = YAML.load_file("#{Rails.root.to_s}/config/sysaid.yml")['sysaid']
  
  SysAid.server_settings = {
    :endpoint => sysaid_settings['endpoint'],
    :account => sysaid_settings['account'],
    :username => sysaid_settings['username'],
    :password => sysaid_settings['password']
  }
  
  SYSAID_SUPPORT = true
rescue Errno::ENOENT => e
  logger.warn "config/sysaid.yml is missing. Disabling SysAid support."
end
