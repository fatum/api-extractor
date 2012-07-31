def application_upstart_name(suffix = nil)
  application.gsub('-', '_').gsub(/\W/, '') + (suffix.nil? ? '' : "_#{suffix}"  )
end

def upstart_script_path(app_upstart_name)
  upstart_path = '/etc/init/'
  File.join(upstart_path, app_upstart_name + '.conf')
end

UPSTART_ACTIONS = [:start, :stop]
UPSTART_ACTION_REQUIRED_START_STATUS = { :start => '-ne 0', :stop => '-eq 0' }

def do_upstart_action(action, app_name)
  raise "Bad upstart action: #{action}, allowed are #{UPSTART_ACTIONS.inspect}" unless UPSTART_ACTIONS.include?(action)
  app = 'api-' + app_name
  upstart_path = upstart_script_path(app)
  cond = UPSTART_ACTION_REQUIRED_START_STATUS[action]
  run <<-CMD
    sudo /sbin/initctl status #{app} | grep start;
    if [ \$? #{cond} ] && [ -f #{upstart_path} ];
    then
      sudo #{action} #{app};
    else
      true;
    fi
  CMD
end
