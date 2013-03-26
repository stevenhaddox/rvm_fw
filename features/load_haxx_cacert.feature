Feature:
  As a user
  I should be able to access a current CA Certificate
  Such that OpenSSL can be configured with modern information.

  Scenario: User visits the OpenSSL Haxx CA Certificate page
    Given I am on the Haxx CA page
    Then I should see "ca-bundle.crt"
