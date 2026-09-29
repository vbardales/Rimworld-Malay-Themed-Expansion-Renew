# TEST_SCENARIOS.md 3 and 4, the reading of the job report in French. Played only by the French pass: the English
# pass excludes this file with a filter term, !08-reports-french. The French words are the DefInjected reportStrings
# the mod carries (Languages/French/DefInjected/JobDef/MalayFix.xml). Developer mode, in which every Pickle run goes,
# shows a missing key as accented gibberish; a report that reads plain English in a French pass never went through
# Translate.
Feature: the job reports in French

  Background:
    Given the save "test-colony" is loaded

  @timeout:180
  Scenario: the dam haji report reads in French
    Given a colonist "Lecteur-1" exists
    And "Lecteur-1" needs "Joy" is set to 10 percent
    And I spawn a "NSTRDamHaji" at (146, 158)
    And game speed is ultrafast
    When Malay Themed Expansion Renew: the joy giver "MalayFix_Play_DamHaji" sends "Lecteur-1" to the "NSTRDamHaji"
    Then Malay Themed Expansion Renew: "Lecteur-1" is using the "NSTRDamHaji" for the job "MalayFix_Play_DamHaji"
    And Malay Themed Expansion Renew: the job report of "Lecteur-1" contains "joue au dam haji"

  @review @timeout:180
  Scenario: the weaving report resolves TargetA to the building in French
    Given a colonist "Lecteur-2" exists
    And "Lecteur-2" needs "Joy" is set to 10 percent
    And I spawn a "NSTRWeaveSpot" at (146, 162)
    And game speed is ultrafast
    When Malay Themed Expansion Renew: the joy giver "MalayFix_Weave" sends "Lecteur-2" to the "NSTRWeaveSpot"
    Then Malay Themed Expansion Renew: "Lecteur-2" is using the "NSTRWeaveSpot" for the job "MalayFix_Weave"
    And Malay Themed Expansion Renew: the job report of "Lecteur-2" contains "tisse sur"
    And Malay Themed Expansion Renew: the job report of "Lecteur-2" holds no unresolved text
    When I select "Lecteur-2"
    And I take a screenshot "weaving-report-french"
