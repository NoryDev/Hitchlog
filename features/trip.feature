Feature: Trip feature

  Scenario: Going to the trips page when logged in and ensure links
    Given I am logged in as alex
    When I go to the trips page
    Then I should see "New Trip"
    
  Scenario: Creating new trips
    Given I am logged in as alex
    When I go to the new trip page
    And I fill in the following:
      | From                          | Belgrade   |
      | To                            | Odessa     |
      | When (format: mm/dd/yyyy)     | 20/10/2010 |
      | Number of rides               | 3          |
      | Time the trip took (in hours) | 1.5        |
    And I press "Submit"
    Then I should see "Thanks for creating a new trip"
