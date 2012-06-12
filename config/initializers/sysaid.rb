# Initializes SysAid based on settings in config/sysaid.yml
sysaid_settings = YAML.load_file("#{Rails.root.to_s}/config/sysaid.yml")['sysaid']

SysAid.server_settings = {
  :endpoint => sysaid_settings['endpoint'],
  :account => sysaid_settings['account'],
  :username => sysaid_settings['username'],
  :password => sysaid_settings['password']
}
