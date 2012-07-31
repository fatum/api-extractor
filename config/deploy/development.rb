set :ssh_options, {:forward_agent => true, :keys => %w{~/.vagrant.d/insecure_private_key}}

role :app, "#{user}@localhost:2222", primary: true
role :db, "#{user}@localhost:2222", primary: true
