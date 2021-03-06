normal[:rbenv][:global] = "1.8.7-p358"
normal[:rbenv][:rubies] = [ "1.8.7-p358" ]
normal[:rbenv][:gems] = { "1.8.7-p358" => [ {"name" => "bundler"} ] }

normal[:passenger][:root_path] = "/usr/local/rbenv/versions/1.8.7-p358/lib/ruby/gems/1.8/gems/passenger-3.0.13"
normal[:passenger][:ruby_bin] = "/usr/local/rbenv/versions/1.8.7-p358/bin/ruby"
normal[:passenger][:version] = "3.0.13"

default[:canvas][:git][:commit] = "d06a9ec1443e5bca03bdf718ddad65137880c0d6"
default[:canvas][:git][:repository] = "https://github.com/instructure/canvas-lms.git"

default[:canvas][:dir] = "/opt/canvas"
default[:canvas][:host] = "canvas.#{node['hostname']}"

default[:canvas][:ssl][:enabled] = false
default[:canvas][:ssl][:key] = "/etc/apache2/ssl/certificate.key"
default[:canvas][:ssl][:cert] = "/etc/apache2/ssl/certificate.crt"

default[:canvas][:user] = "canvas"
default[:canvas][:group] = "canvas"

default[:canvas][:db][:name] = "canvas"
default[:canvas][:db][:user] = "canvas"
default[:canvas][:db][:password] = "canvas"
default[:canvas][:queue_db][:name] = "canvas_queue"

default[:canvas][:ruby][:env] = "test"

default[:canvas][:smtp][:host] = "localhost"
default[:canvas][:smtp][:port] = "25"
default[:canvas][:smtp][:user] = "user"
default[:canvas][:smtp][:password] = "password"
default[:canvas][:smtp][:delivery_method] = "sendmail" # sendmail, test
default[:canvas][:smtp][:authentication] = "plain" # plain, login, or cram_md5
default[:canvas][:smtp][:domain] = "canvas.surfnet.nl"
default[:canvas][:smtp][:outgoing_address] = "info-canvas@surfnet.nl"
default[:canvas][:smtp][:default_name] = "SURFnet Canvas"

default[:canvas][:security][:encryption_key] = "1234567890"

default[:canvas][:admin][:email] = "avandam@zilverline.com"
default[:canvas][:admin][:password] = "secret"

default[:canvas][:auth][:saml][:entity_id] = "http://localhost/saml2"
default[:canvas][:auth][:saml][:contact_name] = "SURFnet Canvas Support"
default[:canvas][:auth][:saml][:contact_email] = "canvas-support@surfnet.nl"
default[:canvas][:auth][:saml][:idp] = "https://engine.surfconext.nl"
default[:canvas][:auth][:saml][:idp_certificate] = "#{canvas['auth']['saml']['idp']}/authentication/idp/certificate"
default[:canvas][:auth][:saml][:logon_url] = "#{canvas['auth']['saml']['idp']}/authentication/idp/single-sign-on"
default[:canvas][:auth][:saml][:login_attribute] = "NameID"
default[:canvas][:auth][:saml][:identifier_format] = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"

default[:canvas][:domain] = "localhost"
