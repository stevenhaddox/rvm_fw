Then /^I should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see a link "([^"]*)"$/ do |link_text|
  page.should have_link(link_text)
end

Given /^I (?:am on|go to) the home page$/ do
  visit root_path
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:|I )should see JSON:$/ do |expected_json|
  require 'json'
  expected = JSON.pretty_generate(JSON.parse(expected_json))
  actual   = JSON.pretty_generate(JSON.parse(response.body))
  expected.should == actual
end
