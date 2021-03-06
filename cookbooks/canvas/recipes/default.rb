include_recipe "java"
include_recipe "ruby_build"
include_recipe "rbenv::system"
include_recipe "apache2"
include_recipe "apache2::mod_ssl" if node[:canvas][:ssl][:enabled]
include_recipe "passenger_apache2::mod_rails"
include_recipe "canvas::coffeescript"
include_recipe "canvas::db"

%w[zlib1g-dev libxml2-dev libxslt-dev libhttpclient-ruby imagemagick libcurl3-dev].each { |p|
    package p
}

group node[:canvas][:group]

user node[:canvas][:user] do
    comment "Canvas LMS User"
    gid "canvas"
    home node[:canvas][:dir]
    shell "/bin/false"
end

execute "clone-canvas-repo" do
    user "root"
    command "git clone #{node[:canvas][:git][:repository]} #{node[:canvas][:dir]} && chown -R #{node[:canvas][:user]}:#{node[:canvas][:group]} #{node[:canvas][:dir]}"
    creates node[:canvas][:dir]
end

execute "checkout a working version" do
  cwd node[:canvas][:dir]
  command "git checkout #{node[:canvas][:git][:commit]}"
end

rbenv_script "bundle-install" do
    cwd node[:canvas][:dir]
    code "bundle install --without postgres"
end

%w[database.yml outgoing_mail.yml security.yml domain.yml delayed_jobs.yml file_store.yml external_migration.yml saml.yml].each { |config_file|
    template "#{node[:canvas][:dir]}/config/" + config_file do
        action :create_if_missing
        owner node[:canvas][:user]
        group node[:canvas][:group]
        mode "0640"
        source config_file + ".erb"
    end
}

rbenv_script "Canvas initial setup" do
    cwd node[:canvas][:dir]
    code "RAILS_ENV=#{node[:canvas][:ruby][:env]} rake db:initial_setup"
    not_if "test `mysql -uroot -p#{node[:mysql][:server_root_password]} -D#{node[:canvas][:db][:name]} -e 'show tables' | tail -n +2 | wc -l` -gt 0"
end

rbenv_script "Create admin user" do
    cwd node[:canvas][:dir]
    code "RAILS_ENV=#{node[:canvas][:ruby][:env]} CANVAS_LMS_ADMIN_EMAIL=#{node[:canvas][:admin][:email]} CANVAS_LMS_ADMIN_PASSWORD=#{node[:canvas][:admin][:password]} rake db:configure_admin"
end

rbenv_script "compile assets" do
    cwd node[:canvas][:dir]
    code "rake canvas:compile_assets"
end

web_app "canvas" do
    docroot "#{node[:canvas][:dir]}/public"
    server_aliases []
    server_name node[:canvas][:host]
    rails_env node[:canvas][:ruby][:env]
end

bash "connect to surfconext" do
    cwd node[:canvas][:dir]
    code (<<-END_HEREDOC
      FINGERPRINT=`curl -s #{node[:canvas][:auth][:saml][:idp_certificate]} | openssl x509 -noout -fingerprint | cut -d"=" -f2`; \
      script/runner -e #{node[:canvas][:ruby][:env]} "AccountAuthorizationConfig.create(:account => Account.last, :auth_type => 'saml', :log_in_url => '#{node[:canvas][:auth][:saml][:logon_url]}', :identifier_format => '#{node[:canvas][:auth][:saml][:identifier_format]}', :certificate_fingerprint => '$FINGERPRINT', :entity_id => '#{node[:canvas][:auth][:saml][:entity_id]}', :login_attribute => '#{node[:canvas][:auth][:saml][:login_attribute]}')"
    END_HEREDOC
    )
    not_if "/usr/bin/mysql -uroot -p#{node[:mysql][:server_root_password]} -e 'select entity_id from #{node[:canvas][:db][:name]}.account_authorization_configs' | grep -w #{node[:canvas][:auth][:saml][:entity_id]}"
end
