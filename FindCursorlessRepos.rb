require 'json'
require 'git'
require 'httparty'

class FindCursorlessRepos
  attr_accessor :headers
  @@GITHUB_TOKEN = 'token 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'.freeze
  def initialize
    @headers = { 'Authorization' => @@GITHUB_TOKEN }    
  end

  def get_all_talon_forks(page = 1, per_page = 100)
    url = "https://api.github.com/repos/knausj85/knausj_talon/forks?per_page=#{per_page}&page=#{page}"
    get_httparty(url)
  end
  
  def find_cursorless_repository(user_name, _user_id)
    repo_base = 'https://api.github.com/repos/'
    repo_end = '/cursorless-settings'
    url = repo_base + user_name + repo_end;
    puts url;
    get_httparty(url)
  end

  def find_cursorless_nested_repository(url)
    puts url
    response = HTTParty.get(url, headers: headers)
    response.code.to_s == '200'
  end

  def clone_repository(url, user_id, dir)  
    Git.clone(url, dir + user_id.to_s)
  end
  
  def get_httparty(url)
    response = HTTParty.get(url, headers: headers)
    response.code.to_s == '200' ? JSON.parse(response.body) : nil
  end
end

5.times do |i|
  findCursorlessRepos = FindCursorlessRepos.new
  response = findCursorlessRepos.get_all_talon_forks(i + 1)
  if response
    response.each do |fork|
      user_name = fork['owner']['login']
      user_id = fork['owner']['id']
      default_branch = fork['default_branch']
      nested_url_start = fork['html_url']
      nested_url_end = "/tree/#{default_branch}/cursorless-settings"
      nested_url_full = nested_url_start + nested_url_end
      cursorless_response = findCursorlessRepos.find_cursorless_repository(user_name, user_id)

      if cursorless_response
        puts 'cursorless-settings hit!!!'
        findCursorlessRepos.clone_repository(
          cursorless_response['ssh_url'], 
          user_id, 
          'all-cursorless-settings/'
        )

        next
      end

      next unless findCursorlessRepos.find_cursorless_nested_repository(nested_url_full)

      puts 'nested-cursorless-settings hit!!!'
      findCursorlessRepos.clone_repository(fork['ssh_url'], user_id, 'all-nested-cursorless-settings/')
    end
  else
    puts response.code
    puts response.body
  end
end
