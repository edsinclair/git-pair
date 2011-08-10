module GitPair
  module Display
    extend self

    def git_author(authors)
      "#{authors.map { |a| a.name }.join(' & ')} <#{Author.email(authors)}>"
    end
  end
end
