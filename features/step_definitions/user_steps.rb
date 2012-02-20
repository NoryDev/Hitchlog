Given /^a hitchhiker$/ do
  @user = Factory.create :user
end

Given /^a hitchhiker called "([^"]*)"$/ do |username|
  @user = Factory.create :user, username: username
end

Given /^his CS user is "([^"]*)"$/ do |cs_username|
  @user.cs_user = cs_username
  @user.save!
end

Given /^I am logged in$/ do
  visit new_user_session_path
  fill_in "Username", with: @user.username
  fill_in "Password", with: 'password'
  click_button "Sign in"
end

Given /^I logged a trip$/ do
  @user.trips << Factory(:trip)
end

When /^I sign up as "([^"]*)"$/ do |arg1|
  fill_in "Username", :with => 'florian'
  fill_in "Email", :with => 'florian@hitchlog.com'
  fill_in "Password", :with => 'password'
  fill_in "Password confirmation", :with => 'password'
  select  "male", :from => "Gender"
  click_button "Sign up"
end
