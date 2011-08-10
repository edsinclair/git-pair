Feature: seeing authors on console
  In order to see current author
  A user should be able to
  get the author string for a set of initials

  Scenario: No authors have been added
    When I specify the initials "AA BB"
    Then the last command's output should include "Please add some authors first"

  Scenario: A single author
    Given I have added the author "Linus Torvalds <linus@example.net>"
    When I specify the initials "LT"
    Then the last command's output should include "Linus Torvalds <linus@example.net>"

  Scenario: Two authors
    Given I have added the author "Linus Torvalds <linus@example.net>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@example.com"
    When I specify the initials "LT JCH"
    Then the last command's output should include "Linus Torvalds & Junio C Hamano <lt+jch@example.net>"

  Scenario: A single author and the pair email has been set
    Given I have set the pair email to "devs@widgets.com"
    And I have added the author "Linus Torvalds <linus@example.net>"
    When I specify the initials "LT"
    Then the last command's output should include "Linus Torvalds <linus@example.net>"

  Scenario: Pairing with two authors and the pair email has been set
    Given I have set the pair email to "devs@widgets.com"
    And I have added the author "Linus Torvalds <linus@example.net>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    When I specify the initials "LT JCH"
    Then the last command's output should include "Linus Torvalds & Junio C Hamano <devs+lt+jch@widgets.com>"