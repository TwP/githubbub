
begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'githubbub'

task :default => 'spec:run'

PROJ.name = 'githubbub'
PROJ.authors = 'Tim Pease'
PROJ.email = 'tim.pease@gmail.com'
PROJ.url = 'http://codeforpeople.rubyforge.org/githubbub'
PROJ.version = GitHubBub::VERSION
PROJ.rubyforge.name = 'codeforpeople'
PROJ.exclude << 'githubbub.gemspec'
PROJ.readme_file = 'README.rdoc'
PROJ.ignore_file = '.gitignore'
PROJ.rdoc.remote_dir = 'bones'

PROJ.spec.opts << '--color'

PROJ.ann.email[:server] = 'smtp.gmail.com'
PROJ.ann.email[:port] = 587
PROJ.ann.email[:from] = 'Tim Pease'

depend_on 'rubyforge'

# EOF
