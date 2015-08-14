task :build_gem do
  sh "gem build rmvc.gemspec"
end

task :install_gem do
  sh "gem install rmvc-3.2.2.gem"
end

task :default => [:build_gem, :install_gem] do
  puts "All good."
end
