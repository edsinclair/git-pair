Feature: Resetting the pair
  In order reset to the global author
  A user should be able to
  reset to the Global User

  Scenario: resetting the current authors
    Given I have added the author "Linus Torvalds <linus@example.org>"
    And my global Git configuration is setup with user "Global User"
    And I switch to the pair "LT"
    When I reset the current authors
    Then `git pair` should display "Global User" for the current author
