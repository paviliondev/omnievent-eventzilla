# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "omnievent/eventzilla/version"

Gem::Specification.new do |spec|
  spec.name = "omnievent-eventzilla"
  spec.version = OmniEvent::Eventzilla::VERSION
  spec.authors = ["Angus McLeod"]
  spec.email = ["angus@pavilion.tech"]

  spec.summary = "OmniEvent Eventzilla strategy"
  spec.description = "An Eventzilla strategy for OmniEvent"
  spec.homepage = "https://github.com/paviliondev/omnievent-eventzilla"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "omnievent"
  spec.add_dependency "omnievent-api"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "webmock"
end
