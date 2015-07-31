Feature:
  As a user
  I should be able to install & configure chruby
  Such that I can use an alternative environment manager to RVM::FW

  Scenario: User visits the chruby page
    Given I am on the chruby page
    Then I should see "Using chruby with RVM::FW"
    And I should see "wget -O chruby-0.3.9.tar.gz"
    And I should see "wget -O ruby-install-0.5.0.tar.gz"
