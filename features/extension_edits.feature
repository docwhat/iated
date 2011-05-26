Feature: Extension edits files

  As a browser extension
  I want to open text in an editor
  So that I can allow users to edit textareas more elegantly.

  Scenario: Sending text to edit
    Given I have a token
    When I have a textarea to edit
     And the textarea has the id of "foobar"
     And the textarea has a url of "http://example.com/foobarpage.html"
     And I request an extension of ".txt"
     And I POST an /edit request
    Then I expect a valid session id
    And I expect the editor file to have an extension of ".txt"
    And I expect the editor file to have "example.com" in it
    And I expect the editor file to have "foobarpage" in it
    And I expect an editor to be opened

  @wip
  Scenario: First check of text
    Given I have a new session
    When I GET /edit/<session id>/0
    Then I expect a change-count of 0
    And I expect no text to be sent

  @wip
  Scenario: Checking unchanged text
    Given I have a new session
    And the session has been edited 2 times
    When I GET /edit/<session id>/2
    Then I expect a change-count of 2
    And I expect no text to be sent

  @wip
  Scenario: Checking once changed text
    Given I have a new session
    And the session has been edited 2 times
    When I GET /edit/<session id>/1
    Then I expect a change-count of 2
    And I expect the text to be sent

  @wip
  Scenario: Checking twice changed text
    Given I have a new session
    And the session has been edited 3 times
    When I GET /edit/<session id>/1
    Then I expect a change-count of 3
    And I expect the text to be sent
