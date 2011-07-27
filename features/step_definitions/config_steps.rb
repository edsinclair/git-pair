Given /^I have added the author "([^\"]*)"$/ do |name_and_email|
  When %(I add the author "#{name_and_email}")
end

Given /^my global Git configuration is setup with user "([^\"]*)"$/ do |name|
  git_config "--global user.name \"#{name}\""
end

Given /^my global Git configuration is setup with email "([^\"]*)"$/ do |email|
  git_config "--global user.email \"#{email}\""
end

When /^I (?:have )?set the domain to "([^"]*)"$/ do |domain|
  git_pair %(--domain "#{domain}")
end

Then /^`git pair` should display "([^"]*)" as its domain$/ do |domain|
  output = git_pair
  assert_equal domain, current_domain_from_output(output)
end

When /^I (?:have )?set the prefix to "([^"]*)"$/ do |prefix|
  git_pair %(--prefix "#{prefix}")
end

Then /^`git pair` should display "([^"]*)" as its prefix$/ do |prefix|
  output = git_pair
  assert_equal prefix, current_prefix_from_output(output)
end

When /^I add the author "([^\"]*)"$/ do |name_and_email|
  git_pair %(--add "#{name_and_email}")
end

When /^I remove the name "([^\"]*)"$/ do |name|
  git_pair %(--remove "#{name}")
end

When /^I (?:try to )?switch to the pair "([^\"]*)"$/ do |abbreviations|
  @output = git_pair abbreviations
end

When /^I reset the current authors$/ do
  git_pair '--reset'
end

Then /^`git pair` should display "([^\"]*)" in its author list$/ do |name|
  output = git_pair
  authors = authors_list_from_output(output)
  assert authors.include?(name)
end

Then /^`git pair` should display "([^\"]*)" in its author list only once$/ do |name|
  output = git_pair
  authors = authors_list_from_output(output)
  assert_equal 1, authors.select { |author| author == name}.size
end

Then /^`git pair` should display no authors$/ do
  output = git_pair
  authors = authors_list_from_output(output)
  authors.size.should be_zero
end


Then /^`git pair` should display "([^\"]*)" for the current author$/ do |names|
  output = git_pair
  assert_equal names, current_author_from_output(output)
end

Then /^`git pair` should display "([^\"]*)" for the current email$/ do |email|
  output = git_pair
  assert_equal email, current_email_from_output(output)
end

Then /^the gitconfig should include "([^\"]*)" in its author list only once$/ do |name|
  output = git_config
  authors = output.split("\n").map { |line| line =~ /^git-pair\.authors=(.*) <[^>]+>$/; $1 }.compact
  assert_equal 1, authors.select { |author| author == name}.size
end

Then /^the gitconfig should include "([^\"]*)" as the email of "([^\"]*)"$/ do |email, name|
  output = git_config
  authors = output.split("\n").map { |line| line =~ /^git-pair\.authors=.* <([^>]+)>$/; $1 }.compact
  assert_equal 1, authors.select { |author| author == email}.size
end

Then /^`git pair` should display the following author list:$/ do |table|
  output = git_pair
  names = authors_list_from_output(output).map { |name| {"name" => name} }
  table.diff! names
end

Then /^`git pair` should display an empty author list$/ do
  output = git_pair
  assert authors_list_from_output(output).empty?
end

Then /^the last command's output should include "([^\"]*)"$/ do |output|
  assert @output.include?(output)
end

Then /^the config file should have no authors$/ do
  git_config(%(--global --get-all git-pair.authors)).should == ''
end

def current_prefix_from_output(output)
  output =~ /Prefix: (.*?)\n/im
  $1.strip
end

def current_domain_from_output(output)
  output =~ /Domain: (.*?)\n/im
  $1.strip
end

def authors_list_from_output(output)
  output =~ /Author list: (.*?)\n\s?\n/im
  $1.strip.split("\n").map { |name| name.strip }
end

def current_author_from_output(output)
  output =~ /Current author: (.*?)\n/im
  $1.strip
end

def current_email_from_output(output)
  output =~ /Current email: (.*?)\n/im
  $1.strip
end
