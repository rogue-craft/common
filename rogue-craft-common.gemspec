
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "rogue-craft-common"
  spec.version       = "0.1.0"
  spec.authors       = ["Isty001"]
  spec.email         = ["isty001@gmail.com"]

  spec.summary       = %q{: Write a short summary, because RubyGems requires one.}
  spec.description   = %q{: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/rogue-craft/common"
  spec.license       = "GPL-3.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = ": Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir['README.md', 'VERSION', 'Gemfile', 'Rakefile', '{bin,lib,config,vendor}/**/*']

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "msgpack", "~> 1.4"
  spec.add_runtime_dependency "dry-validation", "~> 1.7"

  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.14"
  spec.add_development_dependency  "mocha", "~> 1.13"

  spec.add_development_dependency "codecov", "~> 0.6"
  spec.add_development_dependency "simplecov", "~> 0.21"
end
