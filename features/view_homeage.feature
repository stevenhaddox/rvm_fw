Feature: 
  As a user
  I should be able to view the homepage
  Such that I can know what RVM::FW is for.

  Scenario: User visits the homepage
    Given I am on the homepage
    Then I should see "RVM::FW"
    And I should see "Exposing hidden Rubies for firewalled RVM's."
