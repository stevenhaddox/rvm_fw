Feature: 
  As a user
  I should be able to load the customized RVM config
  Such that RVM can know where internal Rubies live.

  Scenario: User visits the custom RVM config page
    Given I am on the RVM config page
    Then I should see "# Rubies"
    And I should see "# Packages"
