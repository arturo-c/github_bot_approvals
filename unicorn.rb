# config/unicorn.rb
@dir = ENV['PRAPPROVAL_ROOT'] || '/mnt/apci/prapproval'
listen 4567, :tcp_nopush => true
worker_processes 2
preload_app true
timeout 280
pid '/tmp/unicorn.prapproval.pid'
before_fork do |server, worker|
  old_pid = '/tmp/unicorn.prapproval.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill('QUIT', File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
end
