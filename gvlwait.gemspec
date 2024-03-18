require_relative "lib/gvlwait/version"

Gem::Specification.new do |spec|
  spec.name        = "gvlwait"
  spec.version     = Gvlwait::VERSION
  spec.authors     = ["Vishnu M"]
  spec.email       = ["vishnumurali7000@gmail.com"]
  spec.summary     = "Measure GVL wait time"
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.1"
  spec.add_dependency "gvltools", "~> 0.4.0"
  spec.add_dependency "concurrent-ruby", ">= 1.2.0"
end
