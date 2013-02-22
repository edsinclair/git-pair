# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "git-pair/version"

Gem::Specification.new do |s|
  s.name        = "edsinclair-git-pair"
  s.version     = GitPair::VERSION
  s.authors     = ["Chris Kampmeier", "Adam McCrea", "Jon Distad", "Eirik Dentz Sinclair", "Tim Gildea"]
  s.email       = ["eirikdentz@gmail.com"]
  s.homepage    = ""
  s.date        = %q{2013-02-22}
  s.summary     = %q{Configure git to commit as more than one author}
  s.description = %q{A git porcelain for pair programming. Changes git-config's user.name and user.email settings so you can commit as more than one author.}

  s.rubyforge_project = "git-pair"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_development_dependency "cucumber"
  s.add_development_dependency "rake"
end
