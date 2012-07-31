set :ssh_options, {:forward_agent => true, :keys => %w{~/.ssh/id_rsa}}

role :app, "#{user}@178.63.98.150:2222", primary: true
role :db, "#{user}@178.63.98.150:2222", primary: true
