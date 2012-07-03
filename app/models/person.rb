class Person < ActiveResource::Base
  begin
    person_settings = YAML.load_file("#{Rails.root.to_s}/config/dss-rm.yml")['dssrm']

    self.site = person_settings["endpoint"]
    self.user = person_settings["username"]
    self.password = person_settings["password"]
  rescue Errno::ENOENT => e
    Rails.logger.warn "config/dss-rm.yml is missing. Please fix (see config/dss-rm.example.yml)."
  end

  # Required by declarative_authorization to determine access
  def role_symbols
    roles.map { |x| x.to_sym }
  end

  # Returns true if the given symbol is in this.role_symbols
  def has_role?(role_sym)
    role_symbols.include? role_sym
  end
end
