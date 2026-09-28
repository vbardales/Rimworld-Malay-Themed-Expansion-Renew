# TEST_SCENARIOS.md 5, the part a running game can show: the buildings and the bill survive a save and a reload, and the
# providers still serve them afterwards. The save is written by the game with the patch active, so this is the round
# trip of a colony that uses the patch. NOT covered, and left to TEST_SCENARIOS.md 5 by hand: loading a save that was
# written BEFORE the patch existed, with the upstream mod alone. No such fixture is supplied by Pickle and the run
# cannot make one without the patch loaded.
Feature: the colony survives a save and reload

  Background:
    Given the save "test-colony" is loaded

  @timeout:240
  Scenario: the stove, its bill and both recreation buildings survive, and the providers still send colonists
    Given research "NSTR_Malay_Food" is finished
    And a colonist "Keeper" exists
    And "Keeper" needs "Joy" is set to 10 percent
    And I spawn a "NSTRDapur" at (146, 156)
    And I add bill "NSTRCookLemang" to the "NSTRDapur" at (146, 156)
    And I spawn a "NSTRDamHaji" at (146, 158)
    And I spawn a "NSTRWeaveSpot" at (146, 162)
    When I save and reload
    Then the "NSTRDapur" has 1 bills
    And a "NSTRDamHaji" exists
    And a "NSTRWeaveSpot" exists
    And Malay Themed Expansion Renew: exactly 1 joy giver serve the "NSTRDamHaji"
    And Malay Themed Expansion Renew: exactly 1 joy giver serve the "NSTRWeaveSpot"
    Given game speed is ultrafast
    When Malay Themed Expansion Renew: the joy giver "MalayFix_Play_DamHaji" sends "Keeper" to the "NSTRDamHaji"
    Then Malay Themed Expansion Renew: "Keeper" is using the "NSTRDamHaji" for the job "MalayFix_Play_DamHaji"
    And no errors were logged
