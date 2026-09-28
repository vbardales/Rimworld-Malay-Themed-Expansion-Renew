# TEST_SCENARIOS.md 1: the defs as the game's OWN loader built them. The patch operations and def references are
# proved offline (Tests/Run-Tests.ps1); this is the same result after the game has read it, plus the errors only its
# loader can raise. That the Malay stoves and buildings exist at all is the claim of the repair: before it, the
# stoves failed to load on an unresolved mod extension.
Feature: the repaired defs load

  @timeout:90
  Scenario: the stoves, the buildings and the added providers exist
    Then mod "nelim.malaythemedexpansion" is loaded
    And mod "NSTR.Malay.Themed.Expansion" is loaded
    And mod "nelim.malaythemedexpansion" loads after "NSTR.Malay.Themed.Expansion"
    And def "NSTRDapur" of type "ThingDef" exists
    And def "NSTRElectricDapur" of type "ThingDef" exists
    And def "NSTRDamHaji" of type "ThingDef" exists
    And def "NSTRWeaveSpot" of type "ThingDef" exists
    And def "MalayFix_Play_DamHaji" of type "JoyGiverDef" exists
    And def "MalayFix_Weave" of type "JoyGiverDef" exists
    And def "MalayFix_Play_DamHaji" of type "JobDef" exists
    And def "MalayFix_Weave" of type "JobDef" exists

  @timeout:90
  Scenario: the eight Malay recipes resolve their stoves
    Then def "NSTRCookNasiLemak" of type "RecipeDef" exists
    And Malay Themed Expansion Renew: the "NSTRDapur" lists the recipe "NSTRCookNasiLemak"
    And Malay Themed Expansion Renew: the "NSTRDapur" lists the recipe "NSTRCookNasiLemakBulk"
    And Malay Themed Expansion Renew: the "NSTRDapur" lists the recipe "NSTRCookSatay"
    And Malay Themed Expansion Renew: the "NSTRDapur" lists the recipe "NSTRCookSatayBulk"
    And Malay Themed Expansion Renew: the "NSTRDapur" lists the recipe "NSTRCookLemang"
    And Malay Themed Expansion Renew: the "NSTRDapur" lists the recipe "NSTRCookLemangBulk"
    And Malay Themed Expansion Renew: the "NSTRDapur" lists the recipe "NSTRCookKetupat"
    And Malay Themed Expansion Renew: the "NSTRDapur" lists the recipe "NSTRCookKetupatBulk"
    And Malay Themed Expansion Renew: the "NSTRElectricDapur" lists the recipe "NSTRCookLemang"

  # The claim of the whole repair, read from the log rather than from a def: nothing this mod touched was refused.
  # A cross-reference the loader could not resolve is logged by the game before any scenario runs, so this reads the
  # start of the game, not only this scenario.
  @timeout:90
  Scenario: the load raised nothing
    Then no errors were logged
    And no warnings from mod "nelim.malaythemedexpansion"
    And no warning matching "Could not resolve cross-reference" was logged
    And no warning matching "NSTRDapur" was logged
    And no warning matching "NSTRDamHaji" was logged
    And no warning matching "NSTRWeaveSpot" was logged
