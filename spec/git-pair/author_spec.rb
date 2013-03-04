require "spec_helper"
require "git-pair/author"
require "git-pair/email_address"

module GitPair
  describe Author do
    let(:author1) { Author.new("User One <user1@example.com>") }
    let(:author2) { Author.new("User Two <user2@example.com>") }

    describe ".email_address_for" do
      before do
        Config.stub(:pair_email => "")
      end

      it "returns the email of the current author" do
        Author.email_address_for([author1]).should eq("user1@example.com")
      end

      it "returns the email prefixes of the current authors in order separated by '+'" do
        Author.email_address_for([author1, author2]).should eq("user1+user2@example.com")
      end

      context "a pair email address is provided with a local part" do
        before do
          Config.stub(:pair_email => "pair@example-corp.com")
        end

        it "returns the local part of the current author with the pair domain" do
          Author.email_address_for([author1]).should eq("user1@example-corp.com")
        end

        it "returns the pair address local part and the initials of the current authors in order separated by '+'" do
          Author.email_address_for([author1, author2]).should eq("pair+uo+ut@example-corp.com")
        end
      end

      context "a pair email address without a local part" do
        before do
          Config.stub(:pair_email => "@example-corp.com")
        end

        it "returns the local part of the current author with the pair domain" do
          Author.email_address_for([author1]).should eq("user1@example-corp.com")
        end

        it "returns the pair address local part and the initials of the current authors in order separated by '+'" do
          Author.email_address_for([author1, author2]).should eq("user1+user2@example-corp.com")
        end
      end
    end

    describe ".local_part_for" do
      before do
        Config.stub(:pair_email => "")
      end

      it "returns the email address local parts for the authors joined by '+'" do
        Author.local_part_for([author1, author2]).should eq("user1+user2")
      end

      it "returns the email address local parts for the authors in order" do
        Author.local_part_for([author2, author1]).should eq("user2+user1")
        Author.local_part_for([author1, author2]).should eq("user1+user2")
      end
    end

    describe ".domain_for" do
      let(:email_address) { EmailAddress.new("user1@example.com") }

      it "returns the domain part of the email address" do
        Config.stub(:pair_email => "")
        Author.domain_for(email_address).should eq("example.com")
      end

      it "returns the domain part of the pair email address when set" do
        Config.stub(:pair_email => "pair@example-corp.com")
        Author.domain_for(email_address).should eq("example-corp.com")
      end
    end
  end
end
