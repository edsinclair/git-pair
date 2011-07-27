Feature: Switching authors
  In order to indicate which authors are committing
  A user should be able to
  change the currently active pair

  Scenario: No authors have been added
    When I try to switch to the pair "AA BB"
    Then the last command's output should include "Please add some authors first"

  Scenario: Pairing with a single author
    Given I have added the author "Linus Torvalds <linus@example.net>"
    When I switch to the pair "LT"
    Then `git pair` should display "Linus Torvalds" for the current author
    And `git pair` should display "linus@example.net" for the current email

  Scenario: Pairing with two authors
    Given I have added the author "Linus Torvalds <linus@example.net>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@example.com"
    When I switch to the pair "LT JCH"
    Then `git pair` should display "Linus Torvalds & Junio C Hamano" for the current author
    And `git pair` should display "pair+lt+jch@example.net" for the current email

  Scenario: Pairing with two authors the pair email domain is set to the first author
    Given I have added the author "Linus Torvalds <linus@example.net>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    And my global Git configuration is setup with email "devs@example.com"
    When I switch to the pair "JCH LT"
    Then `git pair` should display "Junio C Hamano & Linus Torvalds" for the current author
    And `git pair` should display "pair+jch+lt@example.org" for the current email

  Scenario: Pairing with a single author and the git-pairs.domain and prefix have been set
    Given I have set the domain to "widgets.com"
    And I set the prefix to "devs"
    And I have added the author "Linus Torvalds <linus@example.net>"
    When I switch to the pair "LT"
    Then `git pair` should display "Linus Torvalds" for the current author
    And `git pair` should display "linus@example.net" for the current email

  Scenario: Pairing with two authors and the domain and prefix have been set
    Given I have set the domain to "widgets.com"
    And I have set the prefix to "devs"
    And I have added the author "Linus Torvalds <linus@example.net>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    When I switch to the pair "LT JCH"
    Then `git pair` should display "Linus Torvalds & Junio C Hamano" for the current author
    And `git pair` should display "devs+lt+jch@widgets.com" for the current email

  Scenario: Pairing with two authors and only the prefix has been set
    Given I have set the prefix to "devs"
    And I have added the author "Linus Torvalds <linus@example.net>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    When I switch to the pair "LT JCH"
    Then `git pair` should display "Linus Torvalds & Junio C Hamano" for the current author
    And `git pair` should display "devs+lt+jch@example.net" for the current email

  Scenario: Pairing with two authors and only the domain has been set
    Given I have set the domain to "widgets.com"
    And I have added the author "Linus Torvalds <linus@example.net>"
    And I have added the author "Junio C Hamano <junio@example.org>"
    When I switch to the pair "LT JCH"
    Then `git pair` should display "Linus Torvalds & Junio C Hamano" for the current author
    And `git pair` should display "pair+lt+jch@widgets.com" for the current email