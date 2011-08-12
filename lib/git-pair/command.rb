require 'optparse'
require 'ostruct'
require 'pathname'

module GitPair
  module Command
    extend self

    C_BOLD, C_REVERSE, C_RED, C_RESET = "\e[1m", "\e[7m", "\e[91m", "\e[0m"

    def run!(args)
      options = OpenStruct.new(:update  => true,
                               :authors => [])

      parser = OptionParser.new do |opts|
        opts.banner = highlight('General Syntax:')
        opts.separator '  git pair [reset | authors | options]'

        opts.separator ' '
        opts.separator highlight('Options:')

        opts.on '-a', '--add AUTHOR',    'Add an author. Format: "Author Name <author@example.com>"' do |author|
          options.add_author = Author.new(author)
          Config.add_author(options.add_author)
        end

        opts.on '-r', '--remove NAME', 'Remove an author. Use the full name.' do |name|
          options.remove_author= name
          Config.remove_author options.remove_author
        end

        opts.on '-d', '--reset', 'Reset current author to default (global) config' do
          options.reset = true
          Config.reset
        end

        opts.on '--install-hook', 'Install a post-commit hook for the current repo. See git-pair/hooks/post-commit for more information.' do
          options.symlink = true
        end

        opts.on '--email EMAIL', 'Add a default email address to be used for pairs' do |email|
          puts "Setting email to #{email}"
          options.pair_email = email
          Config.set_pair_email(options.pair_email)
        end

        opts.on '-s', "--show 'aa [bb]'", 'Show the string to be used for the commit author field' do |initials|
          options.update = false
          options.authors = Author.find_all(initials.split(' '))
        end

        opts.separator ' '
        opts.separator highlight('Switching authors:')
        opts.separator '  git pair aa [bb]                   Where AA and BB are any abbreviation of an'
        opts.separator ' '*37 + 'author\'s name. You can specify one or more authors.'

        opts.separator ' '
        opts.separator highlight('Current config:')
        opts.separator author_list.split("\n")
        opts.separator ' '
        opts.separator pair_email.split("\n")
        opts.separator ' '
        opts.separator current_author_info.split("\n")
      end

      initials = parser.parse!(args.dup)

      initials = initials.map { |e| e.split(' ') }.flatten # in case initials are enclosed in quotes

      if options.authors.empty? && !initials.empty?
        options.authors = Author.find_all(initials)
      end

      if args.empty?
        puts parser.help
      elsif options.authors && !options.update
        puts Display.git_author options.authors
      elsif options.symlink
        symlink_post_commit_hook
      elsif options.authors.empty?
        puts author_list
        puts
        puts current_author_info
      else
        Config.switch(options.authors)
        puts current_author_info
      end

    rescue OptionParser::MissingArgument
      abort "missing required argument", parser.help
    rescue OptionParser::InvalidOption, OptionParser::InvalidArgument => e
      abort e.message.sub(':', ''), parser.help
    rescue NoMatchingAuthorsError => e
      abort e.message, "\n" + author_list
    rescue MissingConfigurationError => e
      abort e.message, parser.help
    rescue Author::InvalidAuthorString => e
      abort e.message, parser.help
    end

    def author_list
      "     #{bold 'Author list:'} #{Author.all.sort.map { |a| a.name }.join "\n                  "}"
    end

    def pair_email
      "      #{bold 'Pair email:'} #{Config.pair_email} \n"
    end

    def current_author_info
      "  #{bold 'Current author:'} #{Config.current_author}\n" +
      "   #{bold 'Current email:'} #{Config.current_email}\n "
    end

    def abort(error_message, extra = "")
      super red(" Error: #{error_message}\n") + extra
    end

    def highlight(string)
      "#{C_REVERSE}#{string}#{C_RESET}"
    end

    def bold(string)
      "#{C_BOLD}#{string}#{C_RESET}"
    end

    def red(string)
      "#{C_RED}#{C_REVERSE}#{string}#{C_RESET}"
    end

    def symlink_post_commit_hook
      this_directory    = Pathname.new File.expand_path(File.dirname(__FILE__))
      post_commit_hook  = Pathname.new(File.join(this_directory, "..", "..", "hooks", "post-commit")).realpath
      project_git_hooks = File.join(Dir.pwd, ".git", "hooks")

      if File.exists?(post_commit_hook) && File.exists?(project_git_hooks)
        symlink_target = Pathname.new(File.join(project_git_hooks, "post-commit"))

        puts "Symlinking: #{symlink_target}\nto #{post_commit_hook}.\n\n"

        if File.exists?(symlink_target)
          puts "Can't create symlink! #{symlink_target} already exists."
        else
          symlink_target.make_symlink(post_commit_hook)
          puts "Succceded!"
        end
      elsif !File.exists?(project_git_hooks)
        puts "The current directory doesn't appear to be a valid git repository."
      end
    end
  end
end

