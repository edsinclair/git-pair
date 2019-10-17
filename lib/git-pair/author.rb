module GitPair
  class Author

    ValidAuthorStringRegex = /^\s*([^<]+)<([^>]+)>\s*$/

    class InvalidAuthorString < TypeError; end

    def self.all
      Config.all_author_strings.map { |string| new(string) }
    end

    def self.find_all(abbrs)
      raise MissingConfigurationError, "Please add some authors first" if all.empty?
      abbrs.map { |abbr| self.find(abbr) }
    end

    def self.find(abbr)
      all.find { |author| author.match?(abbr) } ||
        raise(NoMatchingAuthorsError, "no authors matched #{abbr}")
    end

    def self.email_address_for(authors)
      "#{local_part_for(authors)}@#{domain_for(authors.first.email)}"
    end

    def self.local_part_for(authors)
      return authors.first.email.local_part if authors.size == 1

      if pair_email.local_part && pair_email.local_part != ""
        authors.map(&:initials).unshift(pair_email.local_part).join("+")
      else
        authors.map { |author| author.email.local_part }.join("+")
      end
    end

    def self.domain_for(email_address)
      return pair_email.domain if pair_email.domain
      return email_address.domain
    end

    def self.exists?(author)
      self.all.find { |a| a.name == author.name }
    end

    def self.valid_string?(author_string)
      author_string =~ ValidAuthorStringRegex
    end

    def self.pair_email
      EmailAddress.new(Config.pair_email)
    end

    attr_reader :name, :email

    def initialize(string)
      unless Author.valid_string?(string)
        raise(InvalidAuthorString, "\"#{string}\" is not a valid name and email")
      end

      string =~ ValidAuthorStringRegex
      self.name = $1.to_s.strip
      self.email = EmailAddress.new($2.to_s.strip)
    end

    def <=>(other)
      name.split.last <=> other.name.split.last
    end

    def initials
      name.split.map { |word| word[0].chr }.join.downcase
    end

    def match?(abbr)
      abbr = abbr.downcase
      initials == abbr ||
        name =~ /\b#{Regexp.escape(abbr)}\b/i ||
        email.to_s.downcase == abbr
    end

  private

    attr_writer :name, :email

  end
end
