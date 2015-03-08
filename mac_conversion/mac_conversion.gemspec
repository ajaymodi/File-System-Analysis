require "#{File.dirname(__FILE__)}/lib/address4forensics/version"

Gem::Specification.new do |s|
  s.name = "address4forensics"
  s.version = Address4Forensics::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ["Ajay Modi"]
  s.email = ["mitajakom@gmail.com"]
  s.homepage = "https://github.com/ajaymodi/CNF_Project"
  s.summary = "A computer forensics project focusing on acquisition authentication and analysis"
  s.description = "A computer forensics project focusing on acquisition authentication and analysis. address4forensics is a command line utility for address conversion."
  s.files = Dir.glob("{bin,lib,test,examples,doc,data}/**/*") + %w(README.md)
  s.require_path = 'lib'
  s.executables = ["address4forensics"]
  s.required_ruby_version = ">= 1.9.2"
  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "address4forensics"
end

