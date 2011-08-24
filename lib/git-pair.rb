require "git-pair/version"

module GitPair
  autoload :Command, 'git-pair/command'
  autoload :Author,  'git-pair/author'
  autoload :Config,  'git-pair/config'
  autoload :Display, 'git-pair/display'

  class NoMatchingAuthorsError < ArgumentError; end
  class MissingConfigurationError < RuntimeError; end
end
