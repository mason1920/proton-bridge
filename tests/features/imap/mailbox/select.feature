Feature: IMAP select mailbox
  Background:
    Given there exists an account with username "user@pm.me" and password "password"
    And the account "user@pm.me" has the following custom mailboxes:
      | name  | type   |
      | mbox  | folder |
      | label | label  |
    And bridge starts
    And the user logs in with username "user@pm.me" and password "password"
    And user "user@pm.me" finishes syncing
    And user "user@pm.me" connects and authenticates IMAP client "1"

  Scenario: Select inbox
    When IMAP client "1" selects "INBOX"
    Then it succeeds

  Scenario: Select custom mailbox
    When IMAP client "1" selects "Folders/mbox"
    Then it succeeds

  Scenario: Select custom label
    When IMAP client "1" selects "Labels/label"
    Then it succeeds

  Scenario: Select non-existing mailbox
    When IMAP client "1" selects "qwerty"
    Then it fails
