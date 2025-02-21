Feature: A user can be deleted
  Background:
    Given there exists an account with username "user@pm.me" and password "password"
    And bridge starts
    And the user logs in with username "user@pm.me" and password "password"

  Scenario: Delete a connected user
    When user "user@pm.me" is deleted
    Then user "user@pm.me" is not listed

  Scenario: Delete a disconnected user
    Given user "user@pm.me" logs out
    When user "user@pm.me" is deleted
    Then user "user@pm.me" is not listed