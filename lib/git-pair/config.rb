module GitPair
  module Config
    extend self

    def all_author_strings
      `git config --global --get-all git-pair.authors`.split("\n")
    end

    def all_author_strings
      `git config --global --get-all git-pair.authors`.split("\n")
    end

    def add_author(author)
      unless Author.exists?(author)
        `git config --global --add git-pair.authors "#{author.name} <#{author.email}>"`
      end
    end

    def remove_author(name)
      `git config --global --unset-all git-pair.authors "^#{name} <"`
      `git config --global --remove-section git-pair` if all_author_strings.empty?
    end

    def switch(authors)

      `git config user.name "#{authors.map { |a| a.name }.join(' & ')}"`
      `git config user.email "#{Author.email(authors)}"`
    end

    def reset
      `git config --remove-section user`
    end

    def default_email
      `git config --global --get user.email`.strip
    end

    def current_author
      `git config --get user.name`.strip
    end

    def current_email
      `git config --get user.email`.strip
    end

    def domain
      `git config --global --get git-pair.domain`.strip
    end

    def prefix
      `git config --global --get git-pair.prefix`.strip
    end

    def set_domain(domain)
      `git config --global git-pair.domain "#{domain}"`
    end

    def set_prefix(prefix)
      `git config --global git-pair.prefix "#{prefix}"`
    end
  end
end
