module GitPair
  module Display
    extend self

    def git_author(authors)
      "#{authors.map { |a| a.name }.join(' & ')} <#{Author.email_address_for(authors)}>"
    end
  end
end
