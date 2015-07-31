Feature:
  As a user
  I should be able to install & configure rbenv
  Such that I can use an alternative environment manager to RVM::FW

  Scenario: User visits the chruby page
    Given I am on the rbenv page
    Then I should see "Using rbenv with RVM::FW"
    And I should see "wget -O rbenv-5b9e4f05846f6bd03b09b8572142f53fd7a46e62.tar.gz"
    And I should see "wget -O ruby-build-e932d47195d76d6be9635a012056069e794039e0.tar.gz"
