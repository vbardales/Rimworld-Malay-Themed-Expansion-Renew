# TEST_SCENARIOS.md 7: Joy Rescue beside the patch. Joy Rescue builds a provider for any recreation building nobody
# serves; this patch supplies its own, so the claim is that Joy Rescue leaves both buildings alone and exactly one
# provider serves each. Played only in the pass that stages Joy Rescue (wsl-deps.avec-joyrescue.map): elsewhere the
# requirement skips it, and a skipped scenario is not a passed one.
@requires:nelim.joyrescue
Feature: Joy Rescue does not duplicate the providers

  @timeout:90
  Scenario: each recreation building has exactly one provider with Joy Rescue loaded
    Then mod "nelim.joyrescue" is loaded
    And Malay Themed Expansion Renew: exactly 1 joy giver serve the "NSTRDamHaji"
    And Malay Themed Expansion Renew: exactly 1 joy giver serve the "NSTRWeaveSpot"
    And no errors were logged
