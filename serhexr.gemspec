
$:.push File.expand_path("../lib", __FILE__)
require "serhexr/version"

Gem::Specification.new do |s|
  s.name        = "serhexr"
  s.version     = Serhexr::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Dave Martin"]
  s.email       = ["dave@radiusnetworks.com"]
  s.homepage    = "http://radiusnetworks.com"
  s.summary     = %q{Native gem wrapper around serhex}
  s.description = %q{Wraps the serhex c library using ffi}
  s.license     = "MIT"

  s.add_runtime_dependency "ffi", "~>1.9"
  s.add_development_dependency "rspec", "~>3.2"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end