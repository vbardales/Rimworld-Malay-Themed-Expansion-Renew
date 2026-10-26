# TEST_SCENARIOS.md 2: each Malay meal and its bulk variant, and one vanilla meal, cooked at the wood stove the repair
# brought back. The stove is spawned finished and fuelled, and the research the recipes ask for is marked done: what is
# under test is that the recipes are offered, taken up and produce, not the construction or the research queue.
#
# NOT covered here, and left to TEST_SCENARIOS.md 2 by hand: the ELECTRIC stove cooking (it needs a power net, and the
# only claim the repair makes about it is that its def and recipe list load, asserted in 01), and the recipes other mods
# add to the vanilla stoves, which the repair deliberately stopped inheriting.
#
# Rest and Food are topped up before the wait (found 2026-09-29, first run): at ultrafast speed 120 real seconds of
# "I wait for bill to finish" runs long enough in game time for night to fall, and a colonist whose rest or hunger
# need is not full is put to bed or sent to eat by the schedule before the bill is ever picked up. All nine cases
# failed identically the first time, screenshot showing every colonist asleep well past midnight.
#
# Topping up the needs alone did not fix it (found 2026-09-29, second run): the timetable sends a pawn to bed or
# the table by the hour, not by need level, so a full Rest need still gets overridden once the wait crosses into a
# Sleep block. All nine cases failed identically again, screenshot showing the same colonists asleep. The colonist
# is now also pinned to Work for the full 24 hours (Eden Garden found the same: a pawn on a Joy hour never looks for work).
# 2026-10-12: the generated "Cook" stood idle at the map edge in the 88947ba capture, far from the stove (the stove-faction
# fix alone did not cure it). The suite now drives the save's own colonist Jet, as Eden Garden's bill scenarios do.
Feature: the Malay stove cooks

  Background:
    Given the save "test-colony" is loaded

  @slow @timeout:280
  Scenario Outline: a cook fills the <recipe> bill at the Malay stove
    Given research "NSTR_Malay_Food" is finished
    Then "Jet" can do "Cooking"
    Given "Jet" skill "Cooking" is set to level 10
    And "Jet" needs "Rest" is set to 100 percent
    And "Jet" needs "Food" is set to 100 percent
    And Malay Themed Expansion Renew: "Jet" is scheduled to work all day
    And Malay Themed Expansion Renew: an open field near "Jet" is cleared
    And Malay Themed Expansion Renew: 100 "RawRice" is spawned in the field at (3, 3)
    And Malay Themed Expansion Renew: 60 "Meat_Muffalo" is spawned in the field at (3, 4)
    And Malay Themed Expansion Renew: I build a "NSTRDapur" in the field at (10, 3)
    And Malay Themed Expansion Renew: the "NSTRDapur" is fuelled
    And I set "Jet" priority "Cooking" to 1
    And I set "Jet" priority "Hauling" to 0
    And I set "Jet" priority "Cleaning" to 0
    And I add bill "<recipe>" to the "NSTRDapur"
    Then the "NSTRDapur" has 1 bills
    And Malay Themed Expansion Renew: "Jet" is offered a bill job at the "NSTRDapur"
    Given game speed is ultrafast
    When Malay Themed Expansion Renew: I wait for the bills of the "NSTRDapur" to finish, explaining why "Jet" does not
    Then a "<product>" exists
    And no errors were logged

    Examples:
      | recipe                | product       |
      | NSTRCookNasiLemak     | NSTRNasiLemak |
      | NSTRCookNasiLemakBulk | NSTRNasiLemak |
      | NSTRCookSatay         | NSTRSatay     |
      | NSTRCookSatayBulk     | NSTRSatay     |
      | NSTRCookLemang        | NSTRLemang    |
      | NSTRCookLemangBulk    | NSTRLemang    |
      | NSTRCookKetupat       | NSTRKetupat   |
      | NSTRCookKetupatBulk   | NSTRKetupat   |
      | CookMealSimple        | MealSimple    |

  # Control (2026-10-26): the same scene with the vanilla wood stove. Green here and red above means the NSTRDapur is
  # the cause; red here too means the scene or the colonist is. Either way the failure message carries the diagnosis.
  @slow @timeout:280
  Scenario: a cook fills the CookMealSimple bill at the vanilla wood stove
    Given Malay Themed Expansion Renew: "Jet" is scheduled to work all day
    Then "Jet" can do "Cooking"
    Given "Jet" skill "Cooking" is set to level 10
    And "Jet" needs "Rest" is set to 100 percent
    And "Jet" needs "Food" is set to 100 percent
    And Malay Themed Expansion Renew: an open field near "Jet" is cleared
    And Malay Themed Expansion Renew: 100 "RawRice" is spawned in the field at (3, 3)
    And Malay Themed Expansion Renew: I build a "FueledStove" in the field at (10, 3)
    And Malay Themed Expansion Renew: the "FueledStove" is fuelled
    And I set "Jet" priority "Cooking" to 1
    And I set "Jet" priority "Hauling" to 0
    And I set "Jet" priority "Cleaning" to 0
    And I add bill "CookMealSimple" to the "FueledStove"
    Then Malay Themed Expansion Renew: "Jet" is offered a bill job at the "FueledStove"
    Given game speed is ultrafast
    When Malay Themed Expansion Renew: I wait for the bills of the "FueledStove" to finish, explaining why "Jet" does not
    Then a "MealSimple" exists
    And no errors were logged
