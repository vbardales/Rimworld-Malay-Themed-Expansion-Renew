# TEST_SCENARIOS.md 3: the dam haji board, given a joy giver by the repair. The giver is asked directly, the way
# JobGiver_GetJoy asks each giver (CanBeGivenTo, then TryGiveJob), instead of waiting for recreation time to pick it:
# how often that happens is baseChance, a die roll the base game owns. What the giver decides once picked is decided
# here, and the job it hands out is started as the game starts it.
#
# The job report is checked for unresolved tokens in whatever language the pass runs in; its wording is asserted in
# 07-reports-english and 08-reports-french.
Feature: a colonist plays dam haji

  Background:
    Given the save "test-colony" is loaded

  @timeout:180
  Scenario: a colonist with low joy is sent to the board and plays with no seat beside it
    Given a colonist "Player" exists
    And "Player" needs "Joy" is set to 10 percent
    And I spawn a "NSTRDamHaji" at (146, 158)
    And game speed is ultrafast
    When Malay Themed Expansion Renew: the joy giver "MalayFix_Play_DamHaji" sends "Player" to the "NSTRDamHaji"
    Then Malay Themed Expansion Renew: "Player" is using the "NSTRDamHaji" for the job "MalayFix_Play_DamHaji"
    And Malay Themed Expansion Renew: the driver of "Player" is a JobDriver_SitFacingBuilding
    And Malay Themed Expansion Renew: the job report of "Player" holds no unresolved text
    When I wait 600 ticks
    Then Malay Themed Expansion Renew: "Player"'s joy has risen since the giver sent them
    And Malay Themed Expansion Renew: "Player" has built up tolerance for the joy kind "Gaming_Cerebral"
    And no errors were logged

  @timeout:180
  Scenario: a colonist plays with a chair standing beside the board
    Given a colonist "Seated" exists
    And "Seated" needs "Joy" is set to 10 percent
    And I spawn a "NSTRDamHaji" at (146, 158)
    And I spawn a "DiningChair" at (146, 159)
    And game speed is ultrafast
    When Malay Themed Expansion Renew: the joy giver "MalayFix_Play_DamHaji" sends "Seated" to the "NSTRDamHaji"
    Then Malay Themed Expansion Renew: "Seated" is using the "NSTRDamHaji" for the job "MalayFix_Play_DamHaji"
    And no errors were logged

  # joyMaxParticipants is 2 on the job: a third colonist is offered nothing while two sit.
  @timeout:240
  Scenario: two colonists share the board and a third is offered nothing
    Given a colonist "Pair-1" exists
    And a colonist "Pair-2" exists
    And a colonist "Pair-3" exists
    And "Pair-1" needs "Joy" is set to 10 percent
    And "Pair-2" needs "Joy" is set to 10 percent
    And "Pair-3" needs "Joy" is set to 10 percent
    And I spawn a "NSTRDamHaji" at (146, 158)
    And game speed is ultrafast
    When Malay Themed Expansion Renew: the joy giver "MalayFix_Play_DamHaji" sends "Pair-1" to the "NSTRDamHaji"
    And Malay Themed Expansion Renew: the joy giver "MalayFix_Play_DamHaji" sends "Pair-2" to the "NSTRDamHaji"
    Then Malay Themed Expansion Renew: "Pair-1" is using the "NSTRDamHaji" for the job "MalayFix_Play_DamHaji"
    And Malay Themed Expansion Renew: "Pair-2" is using the "NSTRDamHaji" for the job "MalayFix_Play_DamHaji"
    And Malay Themed Expansion Renew: the joy giver "MalayFix_Play_DamHaji" offers "Pair-3" nothing
