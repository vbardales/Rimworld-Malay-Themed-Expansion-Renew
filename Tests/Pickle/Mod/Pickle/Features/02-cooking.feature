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
# is now also pinned to Anything for the full 24 hours.
Feature: the Malay stove cooks

  Background:
    Given the save "test-colony" is loaded

  @slow @timeout:280
  Scenario Outline: a cook fills the <recipe> bill at the Malay stove
    Given research "NSTR_Malay_Food" is finished
    And a colonist "Cook" exists
    And "Cook" has childhood "ShopKid36"
    And "Cook" has backstory "Blacksmith7"
    Then "Cook" can do "Cooking"
    Given "Cook" skill "Cooking" is set to level 10
    And "Cook" needs "Rest" is set to 100 percent
    And "Cook" needs "Food" is set to 100 percent
    And Malay Themed Expansion Renew: "Cook" is scheduled to work all day
    When I create a stockpile from (150, 160) to (152, 162)
    And 100 "RawRice" is spawned at the stockpile
    And 60 "Meat_Muffalo" is spawned at the stockpile
    And I spawn a "NSTRDapur" at (146, 156)
    And Malay Themed Expansion Renew: the "NSTRDapur" is fuelled
    And I set "Cook" priority "Cooking" to 1
    And I add bill "<recipe>" to the "NSTRDapur" at (146, 156)
    Then the "NSTRDapur" has 1 bills
    Given game speed is ultrafast
    When I wait for bill "<recipe>" to finish
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
