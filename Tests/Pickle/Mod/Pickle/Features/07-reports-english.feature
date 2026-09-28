# TEST_SCENARIOS.md 3 and 4, the reading of the job report in English. Played only by the English pass: the French
# pass excludes this file with a filter term, !07-reports-english. Language is chosen at launch and never switched
# inside a scenario. The English words are the reportStrings of the patch itself.
Feature: the job reports in English

  Background:
    Given the save "test-colony" is loaded

  @timeout:180
  Scenario: the dam haji report reads in English
    Given a colonist "Reader-1" exists
    And "Reader-1" needs "Joy" is set to 10 percent
    And I spawn a "NSTRDamHaji" at (146, 158)
    When Malay Themed Expansion Renew: the joy giver "MalayFix_Play_DamHaji" sends "Reader-1" to the "NSTRDamHaji"
    Then Malay Themed Expansion Renew: "Reader-1" is using the "NSTRDamHaji" for the job "MalayFix_Play_DamHaji"
    And Malay Themed Expansion Renew: the job report of "Reader-1" contains "playing dam haji"

  @review @timeout:180
  Scenario: the weaving report resolves TargetA to the building in English
    Given a colonist "Reader-2" exists
    And "Reader-2" needs "Joy" is set to 10 percent
    And I spawn a "NSTRWeaveSpot" at (146, 162)
    When Malay Themed Expansion Renew: the joy giver "MalayFix_Weave" sends "Reader-2" to the "NSTRWeaveSpot"
    Then Malay Themed Expansion Renew: "Reader-2" is using the "NSTRWeaveSpot" for the job "MalayFix_Weave"
    And Malay Themed Expansion Renew: the job report of "Reader-2" contains "weaving at"
    And Malay Themed Expansion Renew: the job report of "Reader-2" holds no unresolved text
    When I select "Reader-2"
    And I take a screenshot "weaving-report-english"
