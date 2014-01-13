
# -*- encoding: utf-8 -*-
$:.push('lib')
require "byggvir/version"

Gem::Specification.new do |s|
  s.name     = "byggvir"
  s.version  = Byggvir::VERSION.dup
  s.date     = "2014-01-13"
  s.summary  = "Command line tool for ruby2.1"
  s.email    = "todo@project.com"
  s.homepage = "http://todo.project.com/"
  s.authors  = ['Me Todo']

  s.description = <<-EOF
Command line parser for new ruby2.1 functionality
EOF

  dependencies = [
    # Examples:
    # [:runtime,     "rack",  "~> 1.1"],
    # [:development, "rspec", "~> 2.1"],
  ]

  s.files         = Dir['**/*']
  s.test_files    = Dir['test/**/*'] + Dir['spec/**/*']
  s.executables   = Dir['bin/*'].map { |f| File.basename(f) }
  s.require_paths = ["lib"]


  ## Make sure you can build the gem on older versions of RubyGems too:
  s.rubygems_version = "2.2.1"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.specification_version = 3 if s.respond_to? :specification_version

  dependencies.each do |type, name, version|
    if s.respond_to?("add_#{type}_dependency")
      s.send("add_#{type}_dependency", name, version)
    else
      s.add_dependency(name, version)
    end
  end
end
