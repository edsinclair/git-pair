Feature: Setting a pair email
  In order to commit as a pair
  A user should be able to
  set a pair email address

  Scenario: setting a pair email
    When I set the pair email to "pair@widgets.com"
    Then `git pair` should display "pair@widgets.com" as its pair email