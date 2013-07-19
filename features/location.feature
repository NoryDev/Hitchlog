Feature: Location
  In order to find hitchhikers based on the location
  As a hitchhiker
  I want to be able to enter my location and get it parsed to lat and lng

  Background:
    Given I am logged in as "flov" from "Cairns"

  @javascript @google_maps
  Scenario: Changing location
    When I go to the edit profile page of Flov
    And I enter a new location "Melbourne, Australia"
    And I submit the form
    Then "flov" should have "Melbourne" as city
    And "flov" should have the lat and lng from Melbourne
    And on the profile page of "flov" I should see that he is currently in "Australia, Melbourne"
