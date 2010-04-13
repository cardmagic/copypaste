require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'rake/contrib/rubyforgepublisher'
require 'lib/copypaste'

PKG_VERSION = CopyPaste::VERSION

PKG_FILES = FileList[
    "lib/**/*", "bin/*", "test/**/*", "[A-Z]*", "Rakefile", "doc/**/*", "examples/**/*"
]

desc "Default Task"
task :default => [ :test ]

# Run the unit tests
desc "Run all unit tests"
Rake::TestTask.new("test") { |t|
  t.libs << "lib"
  t.pattern = 'test/*/*_test.rb'
  t.verbose = true
}

# Make a console, useful when working on tests
desc "Generate a test console"
task :console do
   verbose( false ) { sh "irb -I lib/ -r 'copypaste'" }
end

# Genereate the RDoc documentation
desc "Create documentation"
Rake::RDocTask.new("doc") { |rdoc|
  rdoc.title = "CopyPaste - ridiculously easy unix copy and paste functions"
  rdoc.rdoc_dir = 'doc'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
}

# Genereate the package
spec = Gem::Specification.new do |s|

  #### Basic information.

  s.name = 'copypaste'
  s.version = PKG_VERSION
  s.summary = <<-EOF
   CopyPaste provides rcopy, rcut, rpaste unix tools that interact with a central queue server through the memcached protocol
  EOF
  s.description = <<-EOF
   CopyPaste provides rcopy, rcut, rpaste unix tools that interact with a central queue server through the memcached protocol
  EOF

  #### Which files are to be included in this gem?  Everything!  (Except CVS directories.)

  s.files = PKG_FILES

  #### Load-time details: library and application (you will need one or both).

  s.bindir = 'bin'
  s.executables = ['rcopy', 'rcut', 'rpaste']
  s.require_path = 'lib'
  s.autorequire = 'copypaste'
  s.add_dependency('rconfig', '>= 0.3.2')
  s.requirements << "Configuration mangement"
  s.add_dependency('starling', '>= 0.10.1')
  s.requirements << "Queue service"

  #### Documentation and testing.

  s.has_rdoc = true

  #### Author and project details.

  s.author = "Lucas Carlson"
  s.email = "lucas@rufy.com"
  s.homepage = "http://github.com/cardmagic/copypaste"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

desc "Report code statistics (KLOCs, etc) from the application"
task :stats do
  require 'code_statistics'
  CodeStatistics.new(
    ["Library", "lib"],
    ["Units", "test"]
  ).to_s
end