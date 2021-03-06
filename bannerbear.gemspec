require_relative 'lib/bannerbear/version'

Gem::Specification.new do |spec|
  spec.name          = "bannerbear"
  spec.version       = Bannerbear::VERSION
  spec.authors       = ["Jon Yongfook"]
  spec.email         = ["yongfook@gmail.com"]

  spec.summary       = "Ruby wrapper for the Bannerbear API"
  spec.homepage      = "https://github.com/yongfook/bannerbear-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.5.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = ""
  # spec.metadata["changelog_uri"] = ""

  spec.add_dependency "httparty"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
