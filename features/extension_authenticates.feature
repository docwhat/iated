Feature: Extension Authenticates

  As a browser extension
  I want to authenticate
  So that I can send requests

  The token can't be a cookie, or any page sent from the browser could access
  features like editing, etc. That would allow a malicious page to open a million
  editors or change preferences.

  Scenario: Extension says hello
    Given I have not authenticated
    When I GET /hello without a secret
    Then the user should be shown the secret
    And the page should be "text/json"
    And the status should be "ok"

  @wip
  Scenario: Extension posts secret
    Given I have a secret
    When I POST /hello with the secret
    Then I should be sent a response with a token
    And the page should be "text/json"
    And the token should be registered

  Scenario: Extension pings with secret
    Given I have a token
    When I POST /ping with the token
    Then the page should say "pong"
    And the page should be "text/plain"
