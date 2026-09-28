# TEST_SCENARIOS.md 4: the Weave Spot and the joy kind the mod invented for it. NSTRMade_Weave is a ninth kind where the
# base game has eight; a kind nobody produces counts for nothing, so the claim is that a colonist's tolerance for it
# rises after a sitting. TargetA in the job report is checked for resolution here, in whatever language the pass runs.
Feature: a colonist weaves

  Background:
    Given the save "test-colony" is loaded

  @timeout:180
  Scenario: a colonist with low joy weaves and the new joy kind is credited
    Given a colonist "Weaver" exists
    And "Weaver" needs "Joy" is set to 10 percent
    And I spawn a "NSTRWeaveSpot" at (146, 162)
    And game speed is ultrafast
    When Malay Themed Expansion Renew: the joy giver "MalayFix_Weave" sends "Weaver" to the "NSTRWeaveSpot"
    Then Malay Themed Expansion Renew: "Weaver" is using the "NSTRWeaveSpot" for the job "MalayFix_Weave"
    And Malay Themed Expansion Renew: the driver of "Weaver" is a JobDriver_WatchBuilding
    And Malay Themed Expansion Renew: the job report of "Weaver" holds no unresolved text
    When I wait 600 ticks
    Then Malay Themed Expansion Renew: "Weaver"'s joy has risen since the giver sent them
    And Malay Themed Expansion Renew: "Weaver" has built up tolerance for the joy kind "NSTRMade_Weave"
    And no errors were logged
