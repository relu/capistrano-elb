require "capistrano-elb"

Capistrano::Configuration.instance(:must_exist).load do
  namespace :elb do
    capELB = CapELB.new(aws_access_key_id, aws_secret_access_key)
    
    task :remove do 
      servers = roles[:web].servers.map {|server| server.host}
      capELB.remove servers
    end

    task :add do 
      servers = roles[:web].servers.map {|server| server.host}
      capELB.add servers
    end
    
    task :check do 
      puts capELB.check_config
    end
  end
  
  before "deploy", "elb:remove"
  after "deploy", "elb:add"
end
