Feature: Extension Authenticates

  As an extension
  I want to authenticate
  So that I can send requests

  The token can't be a cookie, or any page sent from the browser could access
  features like editing, etc. That would allow a malicious page to open a million
  editors or change preferences.

  Scenario: Authenticate
    Given I have not authenticated
    When I GET /hello without a secret
    And the page should be "text/plain"
    And the page should say "ok"
    Then the user should be shown the secret
    When I POST /hello with the secret
    Then I should be sent a response with a token
    When I POST /preferences with the token
    Then I should get a successful page
