require 'optparse'

module GitPair
  module Command
    extend self

    C_BOLD, C_REVERSE, C_RED, C_RESET = "\e[1m", "\e[7m", "\e[91m", "\e[0m"

    def run!(args)
      parser = OptionParser.new do |opts|
        opts.banner = highlight('General Syntax:')
        opts.separator '  git pair [reset | authors | options]'

        opts.separator ' '
        opts.separator highlight('Options:')
        opts.on '-a', '--add AUTHOR',    'Add an author. Format: "Author Name <author@example.com>"' do |author|
          Config.add_author Author.new(author)
        end
        opts.on '-r', '--remove NAME', 'Remove an author. Use the full name.' do |name|
          Config.remove_author name
        end
        opts.on '-d', '--reset', 'Reset current author to default (global) config' do
          Config.reset
        end
        opts.on '--domain DOMAIN', 'Add a default email domain to be used for pairs' do |domain|
          puts "Setting domain to #{domain}"
          Config.set_domain domain
        end
        opts.on '--prefix PREFIX', 'Add a default email prefix to be used for pairs' do |prefix|
          puts "Setting prefix to #{prefix}"
          Config.set_prefix prefix
        end

        opts.separator ' '
        opts.separator highlight('Switching authors:')
        opts.separator '  git pair aa [bb]                   Where AA and BB are any abbreviation of an'
        opts.separator ' '*37 + 'author\'s name. You can specify one or more authors.'

        opts.separator ' '
        opts.separator highlight('Current config:')
        opts.separator author_list.split("\n")
        opts.separator ' '
        opts.separator domain.split("\n")
        opts.separator prefix.split("\n")
        opts.separator ' '
        opts.separator current_author_info.split("\n")
      end

      authors = parser.parse!(args.dup)

      if args.empty?
        puts parser.help
      elsif authors.empty?
        puts author_list
        puts
        puts current_author_info
      else
        Config.switch Author.find_all(authors)
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

    def domain
      "          #{bold 'Domain:'} #{Config.domain} \n"
    end

    def prefix
      "          #{bold 'Prefix:'} #{Config.prefix} \n"
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

  end
end

