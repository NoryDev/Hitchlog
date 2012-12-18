Feature: Visitors views trips
  In order to view my trips
  As a visitor
  I want to see all trips and see particular trips
  Scenario: Show user story on trip
    Given a trip exists
    And the user of this trip is "supertramp"
    And he did the trip 3 days ago
    And the distance was 1000 km
    And it took him 10 hours
    And google maps says it takes 9 hours and 15 minutes
    When I go to the page of this trip
    Then I should see "3 days ago Supertramp hitchhiked 1,000km from Tehran to Shiraz with 1 ride"
    And  I should see "It took 10 hours to do the trip"
    And  I should see "Google maps says it takes 9 hours 15 minutes for this route"
    And  I should see "so Supertramp was 45 minutes slower."
