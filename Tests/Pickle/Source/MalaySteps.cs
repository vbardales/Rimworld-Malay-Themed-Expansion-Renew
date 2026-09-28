using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using RimWorks.Pickle;
using RimWorld;
using Verse;
using Verse.AI;

namespace MalayThemedExpansion.PickleSteps
{
    /// <summary>
    /// The steps of the Malay Themed Expansion Renew suite. The mod ships no assembly: it adds two joy givers and
    /// two jobs to buildings of another mod, so every step reaches them through the game's own types and their
    /// defNames.
    ///
    /// Every step text starts with "Malay Themed Expansion Renew:". Pickle loads the steps of every active suite into
    /// one namespace, and two suites declaring the same text produce "Ambiguous step" on healthy scenarios.
    /// No step spells an English label: the report is compared with text the scenario supplies for its own pass
    /// language, so a French pass and an English pass assert different words about the same behaviour.
    ///
    /// What is deliberately NOT here is what the offline suite (Tests/Run-Tests.ps1) already proves: the patch
    /// operations, the def references, the French coverage.
    /// </summary>
    [PickleSteps]
    public class MalaySteps
    {
        private sealed class Ledger
        {
            public readonly Dictionary<string, float> JoyAtOffer = new Dictionary<string, float>();
        }

        private static Ledger LedgerOf(PickleContext ctx)
        {
            Ledger ledger = null;
            try
            {
                ledger = ctx.Get<Ledger>();
            }
            catch (Exception)
            {
                // nothing remembered yet in this scenario
            }

            if (ledger == null)
            {
                ledger = new Ledger();
                ctx.Set(ledger);
            }

            return ledger;
        }

        // ------------------------------------------------------------------ finding things

        private static Map CurrentMap(PickleContext ctx)
        {
            ctx.Require(Current.Game != null && Find.CurrentMap != null, "load a save first");
            return Find.CurrentMap;
        }

        private static Pawn Colonist(PickleContext ctx, string nickname)
        {
            Map map = CurrentMap(ctx);
            Pawn pawn = map.mapPawns.FreeColonists.FirstOrDefault(p => p.Name is NameTriple triple && triple.Nick == nickname)
                ?? map.mapPawns.FreeColonists.FirstOrDefault(p => p.LabelShort == nickname);
            ctx.Assert(pawn != null, $"no colonist nicknamed \"{nickname}\"");
            return pawn;
        }

        /// <summary>The one building of that def on the map. A scenario spawns exactly one.</summary>
        private static Thing Building(PickleContext ctx, string defName)
        {
            Map map = CurrentMap(ctx);
            ThingDef def = DefDatabase<ThingDef>.GetNamedSilentFail(defName);
            ctx.Assert(def != null, $"no ThingDef \"{defName}\": is Malay Themed Expansion loaded?");
            List<Thing> found = map.listerThings.ThingsOfDef(def);
            ctx.Assert(found.Count == 1, $"expected one {defName} on the map, found {found.Count}");
            return found[0];
        }

        private static int Chebyshev(IntVec3 a, IntVec3 b)
        {
            return Math.Max(Math.Abs(a.x - b.x), Math.Abs(a.z - b.z));
        }

        private static async Task WaitOrExplain(PickleContext ctx, Func<bool> condition, float seconds, Func<string> explain)
        {
            try
            {
                await ctx.WaitUntil(condition, seconds);
            }
            catch (TimeoutException)
            {
                ctx.Assert(false, $"after {seconds:0} s: {explain()}");
            }
        }

        // ------------------------------------------------------------------ the joy giver, asked as the game asks it

        /// <summary>
        /// The chain <c>JobGiver_GetJoy</c> runs for each giver: <c>CanBeGivenTo</c> first, then <c>TryGiveJob</c>.
        /// Asked directly instead of waiting for recreation time to pick the giver: how often it picks it is
        /// <c>baseChance</c>, a die roll the base game owns. Everything the giver decides once picked is decided here.
        /// </summary>
        private static Job Offer(PickleContext ctx, string giverDefName, Pawn pawn, out string why)
        {
            JoyGiverDef def = DefDatabase<JoyGiverDef>.GetNamedSilentFail(giverDefName);
            ctx.Assert(def != null, $"no JoyGiverDef \"{giverDefName}\": the patch did not add it");
            JoyGiver giver = def.Worker;
            if (!giver.CanBeGivenTo(pawn))
            {
                PawnCapacityDef missing = giver.MissingRequiredCapacity(pawn);
                why = missing != null
                    ? $"CanBeGivenTo is false: {pawn.LabelShort} lacks the capacity {missing.defName}"
                    : "CanBeGivenTo is false";
                return null;
            }

            Job job = giver.TryGiveJob(pawn);
            why = job == null ? "CanBeGivenTo holds but TryGiveJob returned no job" : null;
            return job;
        }

        [When("Malay Themed Expansion Renew: the joy giver {string} sends {string} to the {string}")]
        public void SendTo(PickleContext ctx, string giverDefName, string nickname, string buildingDefName)
        {
            Pawn pawn = Colonist(ctx, nickname);
            Thing building = Building(ctx, buildingDefName);
            string why;
            Job job = Offer(ctx, giverDefName, pawn, out why);
            ctx.Assert(job != null, $"the joy giver {giverDefName} offered {nickname} nothing: {why}");
            ctx.Assert(job.targetA.Thing == building,
                $"the giver sent {nickname} to {job.targetA.Thing?.def.defName} at {job.targetA.Cell}, " +
                $"not to the {buildingDefName} at {building.Position}");

            LedgerOf(ctx).JoyAtOffer[nickname] = pawn.needs.joy.CurLevel;
            pawn.jobs.StartJob(job, JobCondition.InterruptForced);
        }

        [Then("Malay Themed Expansion Renew: the joy giver {string} offers {string} nothing")]
        public void OffersNothing(PickleContext ctx, string giverDefName, string nickname)
        {
            Pawn pawn = Colonist(ctx, nickname);
            string why;
            Job job = Offer(ctx, giverDefName, pawn, out why);
            ctx.Assert(job == null,
                $"the joy giver {giverDefName} offered {nickname} a {job?.def.defName} job aimed at " +
                $"{job?.targetA.Thing?.def.defName}, and it should have offered nothing");
        }

        // ------------------------------------------------------------------ what the colonist does

        [Then("Malay Themed Expansion Renew: {string} is using the {string} for the job {string}", TimeoutSeconds = 100f)]
        public async Task IsUsing(PickleContext ctx, string nickname, string buildingDefName, string jobDefName)
        {
            Pawn pawn = Colonist(ctx, nickname);
            Thing building = Building(ctx, buildingDefName);

            await WaitOrExplain(ctx,
                () => pawn.CurJob != null && pawn.CurJob.def.defName == jobDefName && pawn.CurJob.targetA.Thing == building
                      && pawn.jobs.curDriver != null && !pawn.pather.Moving && Chebyshev(pawn.Position, building.Position) <= 2,
                90f,
                () => $"{nickname} is at {pawn.Position}, the {buildingDefName} at {building.Position}; job " +
                      (pawn.CurJob == null ? "none" : pawn.CurJob.def.defName) + ", moving " + pawn.pather.Moving);
        }

        [Then("Malay Themed Expansion Renew: the driver of {string} is a {word}")]
        public void DriverIs(PickleContext ctx, string nickname, string typeName)
        {
            Pawn pawn = Colonist(ctx, nickname);
            string actual = pawn.jobs.curDriver?.GetType().Name;
            ctx.Assert(actual == typeName, $"{nickname} runs a {actual ?? "no driver"}, not a {typeName}");
        }

        [Then("Malay Themed Expansion Renew: the job report of {string} contains {string}")]
        public void ReportContains(PickleContext ctx, string nickname, string text)
        {
            string report = ReportOf(ctx, nickname);
            ctx.Assert(report.IndexOf(text, StringComparison.OrdinalIgnoreCase) >= 0,
                $"the job report of {nickname} is \"{report}\" and does not contain \"{text}\"");
        }

        [Then("Malay Themed Expansion Renew: the job report of {string} holds no unresolved text")]
        public void ReportResolved(PickleContext ctx, string nickname)
        {
            string report = ReportOf(ctx, nickname);
            ctx.Assert(report.IndexOf("TargetA", StringComparison.Ordinal) < 0
                       && report.IndexOf("TargetB", StringComparison.Ordinal) < 0
                       && report.IndexOf('{') < 0 && report.IndexOf('}') < 0,
                $"the job report of {nickname} still holds an unresolved token: \"{report}\"");
        }

        private static string ReportOf(PickleContext ctx, string nickname)
        {
            Pawn pawn = Colonist(ctx, nickname);
            ctx.Assert(pawn.jobs.curDriver != null, $"{nickname} has no job driver, so no job report");
            string report = pawn.jobs.curDriver.GetReport();
            ctx.Assert(!string.IsNullOrWhiteSpace(report), $"the job report of {nickname} is empty");
            return report;
        }

        [Then("Malay Themed Expansion Renew: {string}'s joy has risen since the giver sent them")]
        public void JoyRose(PickleContext ctx, string nickname)
        {
            Pawn pawn = Colonist(ctx, nickname);
            float before;
            ctx.Assert(LedgerOf(ctx).JoyAtOffer.TryGetValue(nickname, out before),
                $"{nickname} was never sent to a building by this scenario");
            float now = pawn.needs.joy.CurLevel;
            ctx.Assert(now > before + 0.005f, $"{nickname}'s joy was {before:0.000} when the giver sent them and is {now:0.000}");
        }

        [Then("Malay Themed Expansion Renew: {string} has built up tolerance for the joy kind {string}")]
        public void HasTolerance(PickleContext ctx, string nickname, string kindDefName)
        {
            Pawn pawn = Colonist(ctx, nickname);
            JoyKindDef kind = DefDatabase<JoyKindDef>.GetNamedSilentFail(kindDefName);
            ctx.Assert(kind != null, $"no JoyKindDef \"{kindDefName}\"");
            float tolerance = pawn.needs.joy.tolerances[kind];
            ctx.Assert(tolerance > 0f, $"{nickname}'s tolerance for {kindDefName} is {tolerance}: the sitting did not credit the kind");
        }

        // ------------------------------------------------------------------ providers, as the def database holds them

        [Then("Malay Themed Expansion Renew: exactly {int} joy giver(s) serve the {string}")]
        public void ProvidersCount(PickleContext ctx, int expected, string buildingDefName)
        {
            List<string> givers = DefDatabase<JoyGiverDef>.AllDefs
                .Where(g => g.thingDefs != null && g.thingDefs.Any(t => t.defName == buildingDefName))
                .Select(g => g.defName)
                .ToList();
            ctx.Assert(givers.Count == expected,
                $"{givers.Count} joy giver(s) serve {buildingDefName}: {string.Join(", ", givers)}; expected {expected}");
        }

        // ------------------------------------------------------------------ the stove

        [Given("Malay Themed Expansion Renew: the {string} is fuelled")]
        public void Fuelled(PickleContext ctx, string buildingDefName)
        {
            Thing stove = Building(ctx, buildingDefName);
            CompRefuelable fuel = stove.TryGetComp<CompRefuelable>();
            ctx.Assert(fuel != null, $"the {buildingDefName} has no refuelable comp: it is not a wood stove");
            fuel.Refuel(fuel.Props.fuelCapacity);
            ctx.Assert(fuel.HasFuel, $"the {buildingDefName} still has no fuel after refuelling");
        }

        [Then("Malay Themed Expansion Renew: the {string} lists the recipe {string}")]
        public void ListsRecipe(PickleContext ctx, string buildingDefName, string recipeDefName)
        {
            ThingDef def = DefDatabase<ThingDef>.GetNamedSilentFail(buildingDefName);
            ctx.Assert(def != null, $"no ThingDef \"{buildingDefName}\"");
            RecipeDef recipe = DefDatabase<RecipeDef>.GetNamedSilentFail(recipeDefName);
            ctx.Assert(recipe != null, $"no RecipeDef \"{recipeDefName}\"");
            ctx.Assert(def.AllRecipes.Contains(recipe),
                $"the {buildingDefName} offers {def.AllRecipes.Count} recipes and \"{recipeDefName}\" is not one of them");
        }
    }
}
