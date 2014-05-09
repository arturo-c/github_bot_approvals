require 'sinatra'
require 'json'
require 'octokit'

TEMP_FILE = '/tmp/github_approvals.txt'

# Provide authentication credentials
Octokit.configure do |c|
  c.access_token = ENV['GITHUB_ACCESS_TOKEN']
end

post '/approvals' do
  approvals = Array.new
  approvals = Marshal.load File.read(TEMP_FILE) if File.file?(TEMP_FILE)
  payload = JSON.parse(params[:payload])
  # If comment is a thumbs up.
  if payload['comment']['body'].include? '+1'
    if approvals.empty? || !approvals.include?(payload['issue']['id'])
      approvals.push(payload['issue']['id'])
    else
      Octokit.add_comment(payload['repository']['name'],payload['issue']['number'],'run tests')
      approvals.delete(payload['issue']['id'])
    end
    File.open(TEMP_FILE, 'w') {|f| f.write(Marshal.dump(approvals)) }
  end
  return true
end
