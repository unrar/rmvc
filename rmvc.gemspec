Gem::Specification.new do |s|
  s.name        = 'rmvc'
  s.version     = '3.2.1'
  s.date        = '2014-12-17'
  s.summary     = 'Ruby MVC'
  s.description = 'Use MVC in your Ruby apps!'
  s.authors     = ["unrar"]
  s.email       = "joszaynka@gmail.com"
  s.files       = ["lib/rmvc/interface.rb", "lib/rmvc/helpers.rb", "lib/rmvc/migrations.rb", "lib/rmvc/core.rb", "lib/rmvc.rb"]
  s.executables << 'rmvc'
  s.homepage    = "http://unrar.github.io/rmvc"
  s.add_runtime_dependency 'colorize', '~> 0'
  s.add_runtime_dependency 'sqlite3', '~> 0'
  s.license     = "MIT"
end
