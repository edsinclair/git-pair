$:.unshift File.dirname(__FILE__)

require 'git-pair/command'
require 'git-pair/author'
require 'git-pair/config'
require 'git-pair/display'

module GitPair

  class NoMatchingAuthorsError < ArgumentError; end
  class MissingConfigurationError < RuntimeError; end

end
