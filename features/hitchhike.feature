Feature: Hitchhike feature

  Scenario: User creates hitchhike with invalid data
    Given I am logged in as alex
    When I go to the new hitchhike page
    And I fill in the following:
      | Title | example   |
    And I press "Submit"
    Then I should see error messages

  Scenario: Hitchhiker creates hitchhike with valid data and a Photo
    Given I am logged in as alex
    When I go to the new hitchhike page
    And I fill in the following:
      | Title   | Trip in eastern Europe |
      | From    | Belgrade               |
      | To      | Odessa                 |
    And I attach the file "features/support/cucumber.jpg" to "Photo"
    And I press "Submit"
    Then I should see "Crop the photo"

  Scenario: Hitchhiker creates hitchhike with valid data without a Photo
    Given I am logged in as alex
    When I go to the new hitchhike page
    And I fill in the following:
      | Title        | Trip in eastern Europe |
      | From         | Belgrade               |
      | To           | Odessa                 |
      | Story        | My Story               |
      | Waiting time | 40                     |
      # Driver:
      | Name       | Alexander Supertramp     |
      | Age        | 24                       |
      | Origin     | Hitchhiker               |
      | Occupation | Hitchhiker               |
      | Mission    | To travel across America |
    And I select "male" from "Gender"
    And I press "Submit"
    Then I should see "Successfully created hitchhike."
    # And I should see "Alexander Supertramp" # selenium testing

    
    Scenario: Make sure that You cannot put in new hitchhikes when you are not logged in
      Given I am not logged in
      And I go to the new hitchhike page
      Then I should see "You need to sign in"
      
    Scenario: User can manage his hitchhikes
      Given I am logged in as alex
      And there is a hitchhike from alex
      And there is a hitchhike from someone else
      When I go to the hitchhikes page
      Then I should see the hitchhike of Alexander but not the other one
    
    
    