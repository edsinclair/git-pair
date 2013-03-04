require "spec_helper"
require "git-pair/email_address"

module GitPair
  describe EmailAddress do
    let(:email_address) { EmailAddress.new("user1@example.com") }

    describe "#local_part" do
      it "returns the local part" do
        email_address.local_part.should eq("user1")
      end
    end

    describe "#domain" do
      it "returns the domain part" do
        email_address.domain.should eq("example.com")
      end

      it "returns nil if initialized with an empty string" do
        EmailAddress.new("").domain.should eq(nil)
      end
    end

    describe "#to_s" do
      it "returns the address as a string" do
        email_address.to_s.should eq("user1@example.com")
      end
    end
  end
end
