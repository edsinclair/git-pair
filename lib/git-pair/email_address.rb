module GitPair
  class EmailAddress
    def initialize(address)
      self.address = address
    end

    def local_part
      address.split("@").first
    end

    def domain
      address.split("@").last
    end

    def to_s
      address
    end

  private
    attr_accessor :address
  end
end
