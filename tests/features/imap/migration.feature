Feature: Bridge can fully sync an account
  Background:
    Given there exists an account with username "user@pm.me" and password "password"
    And the account "user@pm.me" has 20 custom folders
    And the account "user@pm.me" has 60 custom labels
    When bridge starts
    And the user logs in with username "user@pm.me" and password "password"
    And user "user@pm.me" finishes syncing
    When user "user@pm.me" connects and authenticates IMAP client "1"
    Then IMAP client "1" counts 20 mailboxes under "Folders"
    And  IMAP client "1" counts 60 mailboxes under "Labels"

  Scenario: The user changes the gluon path
    When the user changes the gluon path
    And user "user@pm.me" connects and authenticates IMAP client "2"
    Then IMAP client "2" counts 20 mailboxes under "Folders"
    And  IMAP client "2" counts 60 mailboxes under "Labels"