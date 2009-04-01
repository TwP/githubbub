
require 'rubygems'
require 'tempfile'
require 'fileutils'
require 'rubyforge'

class GitHubBub

  # :stopdoc:
  VERSION = '1.0.0'
  # :startdoc:

  def self.version
    VERSION
  end

  def self.run( args )
    self.new.run args
  end

  attr_accessor :gemspec, :github_user

  def initialize
    @gemspec = nil
    @github_user = nil
  end

  def run( args )
    get_user args.first

    load_gemspec
    scrub
    file = build_gem
    publish_gem file
  end

  def get_user( user )
    if user.nil?
      $stdout.write "What is your GitHub handle: "
      $stdout.flush
      orig = $stdin.gets
      user = orig.strip!
    end

    if user.nil? or user.empty?
      puts "You typed in #{orig.inspect} and I don't understand that!"
      puts "Usage:"
      puts "  githubbub [github username]"
      abort
    end

    self.github_user = user
  end

  def load_gemspec
    fn = Dir.glob('*.gemspec').first
    if fn.nil?
      puts "I'm sorry, but I could not find a gemspec file!"
      abort
    end

    code = File.read(fn)
    self.gemspec = eval(code)
  end

  def scrub
    gemspec.files = []
    gemspec.has_rdoc = false
    gemspec.extra_rdoc_files = []
    gemspec.executables = []
    gemspec.default_executable = nil
    gemspec.date = Time.now.strftime("%Y-%m-%d")
    gemspec.instance_variable_get(:@dependencies).clear
    gemspec.bindir = nil
    gemspec
  end

  def build_gem
    dir = Dir.pwd

    path = tempdir
    Dir.chdir path
    write_setup
    write_wrapper

    gemspec.files = Dir.glob('**/*').find_all {|fn| test(?f, fn)}.sort
    gemspec.extensions = Dir.glob('**/extconf.rb').sort
    write_gemspec

    file = Gem::Builder.new(gemspec).build
    FileUtils.mv file, dir
    file
  ensure
    Dir.chdir dir if dir
  end

  def publish_gem( file )
    rf = RubyForge.new
    rf.configure rescue nil
    puts 'Logging in to RubyForge'
    rf.login

    begin
      rf.lookup 'package', gemspec.name
    rescue RuntimeError
      puts "Creating package #{gemspec.name} under #{gemspec.rubyforge_project}"
      rf.create_package gemspec.rubyforge_project, gemspec.name
    end

    puts "Releasing #{gemspec.name} v. #{gemspec.version}"
    rf.add_release gemspec.rubyforge_project, gemspec.name, gemspec.version, file
  end

  def tempdir
    fd = Tempfile.new 'githubbub-gem'
    path = fd.path
    fd.unlink
    FileUtils.mkdir_p path
    #at_exit { FileUtils.rm_rf(path) }
    at_exit { puts path }
    path
  end

  def write_setup
    FileUtils.mkdir 'ext'
    File.open(File.join('ext','extconf.rb'), 'w') do |fd|
      fd.write(SETUP % [gemspec.version, github_user, gemspec.name])
    end
  end

  def write_wrapper
    FileUtils.mkdir 'lib'
    File.open(File.join('lib',"#{gemspec.name}.rb"), 'w') do |fd|
      fd.write(WRAPPER % [github_user, gemspec.name, gemspec.name])
    end
  end

  def write_gemspec
    name = gemspec.name + '.gemspec'
    gemspec.files << name
    File.open(name, 'w') {|fd| fd.write(gemspec.to_ruby)}
  end

  SETUP =<<-SETUP
require 'rbconfig'

# Ruby Interpreter location - taken from Rake source code
RUBY = File.join(Config::CONFIG['bindir'],
                 Config::CONFIG['ruby_install_name']).sub(/.*\s.*/m, '"\&"')

system "\#{RUBY} -S gem install --version '%s' --source http://gems.github.com %s-%s"
File.open('Makefile','w') {|fd| fd.puts "install:\\n\\t@-echo -n ''"}
  SETUP

  WRAPPER =<<-WRAPPER
require 'rubygems'
gem '%s-%s'
require '%s'
  WRAPPER

end  # class Githubbub

# EOF
