Feature: Adding an pair email domain and prefix
  In order to commit as a pair
  A user should be able to
  set a domain and prefix to be used for the pair email address

  Scenario: adding an email domain
    When I set the domain to "widgets.com"
    Then `git pair` should display "widgets.com" as its domain

  Scenario: adding an email address prefix
    When I set the prefix to "pair"
    Then `git pair` should display "pair" as its prefix
