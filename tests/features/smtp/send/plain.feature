Feature: SMTP sending of plain messages
  Background:
    Given there exists an account with username "user@pm.me" and password "password"
    And there exists an account with username "bridgetest@protonmail.com" and password "password"
    And there exists an account with username "bridgetest2@protonmail.com" and password "password"
    And bridge starts
    And the user logs in with username "user@pm.me" and password "password"
    And user "user@pm.me" connects and authenticates SMTP client "1"

  Scenario: Only from and to headers to internal account
    When SMTP client "1" sends the following message from "user@pm.me" to "bridgetest@protonmail.com":
      """
      From: Bridge Test <user@pm.me>
      To: Internal Bridge <bridgetest@protonmail.com>

      hello

      """
    Then it succeeds
    When user "user@pm.me" connects and authenticates IMAP client "1"
    Then IMAP client "1" eventually sees the following messages in "Sent":
      | from       | to                        | subject |
      | user@pm.me | bridgetest@protonmail.com |         |
    And the body in the "POST" request to "/mail/v4/messages" is:
      """
      {
        "Message": {
          "Subject": "",
          "Sender": {
            "Name": "Bridge Test"
          },
          "ToList": [
            {
              "Address": "bridgetest@protonmail.com",
              "Name": "Internal Bridge"
            }
          ],
          "CCList": [],
          "BCCList": [],
          "MIMEType": "text/plain"
        }
      }
      """

  Scenario: Only from and to headers to external account
    When SMTP client "1" sends the following message from "user@pm.me" to "pm.bridge.qa@gmail.com":
      """
      From: Bridge Test <user@pm.me>
      To: External Bridge <pm.bridge.qa@gmail.com>

      hello

      """
    Then it succeeds
    When user "user@pm.me" connects and authenticates IMAP client "1"
    Then IMAP client "1" eventually sees the following messages in "Sent":
      | from       | to                     | subject |
      | user@pm.me | pm.bridge.qa@gmail.com |         |
    And the body in the "POST" request to "/mail/v4/messages" is:
      """
      {
        "Message": {
          "Subject": "",
          "Sender": {
            "Name": "Bridge Test"
          },
          "ToList": [
            {
              "Address": "pm.bridge.qa@gmail.com",
              "Name": "External Bridge"
            }
          ],
          "CCList": [],
          "BCCList": [],
          "MIMEType": "text/plain"
        }
      }
      """

  Scenario: Basic message to internal account
    When SMTP client "1" sends the following message from "user@pm.me" to "bridgetest@protonmail.com":
      """
      From: Bridge Test <user@pm.me>
      To: Internal Bridge <bridgetest@protonmail.com>
      Subject: Plain text internal
      Content-Disposition: inline
      Content-Type: text/plain; charset=utf-8

      This is body of mail 👋

      """
    Then it succeeds
    When user "user@pm.me" connects and authenticates IMAP client "1"
    Then IMAP client "1" eventually sees the following messages in "Sent":
      | from       | to                        | subject             |
      | user@pm.me | bridgetest@protonmail.com | Plain text internal |
    And the body in the "POST" request to "/mail/v4/messages" is:
      """
      {
        "Message": {
          "Subject": "Plain text internal",
          "Sender": {
            "Name": "Bridge Test"
          },
          "ToList": [
            {
              "Address": "bridgetest@protonmail.com",
              "Name": "Internal Bridge"
            }
          ],
          "CCList": [],
          "BCCList": [],
          "MIMEType": "text/plain"
        }
      }
      """

  Scenario: Basic message to external account
    When SMTP client "1" sends the following message from "user@pm.me" to "pm.bridge.qa@gmail.com":
      """
      From: Bridge Test <user@pm.me>
      To: External Bridge <pm.bridge.qa@gmail.com>
      Subject: Plain text external
      Content-Disposition: inline
      Content-Type: text/plain; charset=utf-8

      This is body of mail 👋

      """
    Then it succeeds
    When user "user@pm.me" connects and authenticates IMAP client "1"
    Then IMAP client "1" eventually sees the following messages in "Sent":
      | from       | to                     | subject             |
      | user@pm.me | pm.bridge.qa@gmail.com | Plain text external |
    And the body in the "POST" request to "/mail/v4/messages" is:
      """
      {
        "Message": {
          "Subject": "Plain text external",
          "Sender": {
            "Name": "Bridge Test"
          },
          "ToList": [
            {
              "Address": "pm.bridge.qa@gmail.com",
              "Name": "External Bridge"
            }
          ],
          "CCList": [],
          "BCCList": [],
          "MIMEType": "text/plain"
        }
      }
      """

  Scenario: Message without charset is utf8
    When SMTP client "1" sends the following message from "user@pm.me" to "pm.bridge.qa@gmail.com":
      """
      From: Bridge Test <user@pm.me>
      To: External Bridge <pm.bridge.qa@gmail.com>
      Subject: Plain text no charset external
      Content-Disposition: inline
      Content-Type: text/plain;

      This is body of mail without charset. Please assume utf8

      """
    Then it succeeds
    When user "user@pm.me" connects and authenticates IMAP client "1"
    Then IMAP client "1" eventually sees the following messages in "Sent":
      | from       | to                     | subject                        |
      | user@pm.me | pm.bridge.qa@gmail.com | Plain text no charset external |
    And the body in the "POST" request to "/mail/v4/messages" is:
      """
      {
        "Message": {
          "Subject": "Plain text no charset external",
          "Sender": {
            "Name": "Bridge Test"
          },
          "ToList": [
            {
              "Address": "pm.bridge.qa@gmail.com",
              "Name": "External Bridge"
            }
          ],
          "CCList": [],
          "BCCList": [],
          "MIMEType": "text/plain"
        }
      }
      """

  Scenario: Message without charset is base64-encoded latin1
    When SMTP client "1" sends the following message from "user@pm.me" to "pm.bridge.qa@gmail.com":
      """
      From: Bridge Test <user@pm.me>
      To: External Bridge <pm.bridge.qa@gmail.com>
      Subject: Plain text no charset external
      Content-Disposition: inline
      Content-Type: text/plain;
      Content-Transfer-Encoding: base64

      dGhpcyBpcyBpbiBsYXRpbjEgYW5kIHRoZXJlIGFyZSBsb3RzIG9mIGVzIHdpdGggYWNjZW50czog
      6enp6enp6enp6enp6enp


      """
    Then it succeeds
    When user "user@pm.me" connects and authenticates IMAP client "1"
    Then IMAP client "1" eventually sees the following messages in "Sent":
      | from       | to                     | subject                        |
      | user@pm.me | pm.bridge.qa@gmail.com | Plain text no charset external |
    And the body in the "POST" request to "/mail/v4/messages" is:
      """
      {
        "Message": {
          "Subject": "Plain text no charset external",
          "Sender": {
            "Name": "Bridge Test"
          },
          "ToList": [
            {
              "Address": "pm.bridge.qa@gmail.com",
              "Name": "External Bridge"
            }
          ],
          "CCList": [],
          "BCCList": [],
          "MIMEType": "text/plain"
        }
      }
      """

  Scenario: Message without charset and content is detected as HTML
    When SMTP client "1" sends the following message from "user@pm.me" to "pm.bridge.qa@gmail.com":
      """
      From: Bridge Test <user@pm.me>
      To: External Bridge <pm.bridge.qa@gmail.com>
      Subject: Plain, no charset, no content, external
      Content-Disposition: inline
      Content-Type: text/plain;

      """
    Then it succeeds
    When user "user@pm.me" connects and authenticates IMAP client "1"
    Then IMAP client "1" eventually sees the following messages in "Sent":
      | from       | to                     | subject                                 |
      | user@pm.me | pm.bridge.qa@gmail.com | Plain, no charset, no content, external |
    And the body in the "POST" request to "/mail/v4/messages" is:
      """
      {
        "Message": {
          "Subject": "Plain, no charset, no content, external",
          "Sender": {
            "Name": "Bridge Test"
          },
          "ToList": [
            {
              "Address": "pm.bridge.qa@gmail.com",
              "Name": "External Bridge"
            }
          ],
          "CCList": [],
          "BCCList": [],
          "MIMEType": "text/plain"
        }
      }
      """

  Scenario: RCPT does not contain all CC
    When SMTP client "1" sends MAIL FROM "<user@pm.me>"
    And SMTP client "1" sends RCPT TO "<bridgetest@protonmail.com>"
    And SMTP client "1" sends DATA:
      """
      From: Bridge Test <user@pm.me>
      To: Internal Bridge <bridgetest@protonmail.com>
      CC: Internal Bridge 2 <bridgetest2@protonmail.com>
      Content-Type: text/plain
      Subject: RCPT-CC test

      This is CC missing in RCPT test. Have a nice day!
.
      """
    Then it succeeds
    When user "user@pm.me" connects and authenticates IMAP client "1"
    Then IMAP client "1" eventually sees the following messages in "Sent":
      | from       | to                        | cc                         | subject      |
      | user@pm.me | bridgetest@protonmail.com | bridgetest2@protonmail.com | RCPT-CC test |
    And the body in the "POST" request to "/mail/v4/messages" is:
      """
      {
        "Message": {
          "Subject": "RCPT-CC test",
          "Sender": {
            "Name": "Bridge Test"
          },
          "ToList": [
            {
              "Address": "bridgetest@protonmail.com",
              "Name": "Internal Bridge"
            }
          ],
          "CCList": [
            {
              "Address": "bridgetest2@protonmail.com",
              "Name": "Internal Bridge 2"
            }
          ],
          "BCCList": []
        }
      }
      """
    And the body in the "POST" request to "/mail/v4/messages/.*" is:
      """
      {
        "Packages":[
            {
              "Addresses":{
                  "bridgetest@protonmail.com":{
                    "Type":1
                  },
                  "bridgetest2@protonmail.com":{
                    "Type":1
                  }
              },
              "Type":1,
              "MIMEType":"text/plain"
            }
        ]
      }
      """