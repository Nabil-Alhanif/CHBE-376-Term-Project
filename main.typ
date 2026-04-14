#import "@preview/hydra:0.6.1": hydra
#import "@preview/chemformula:0.1.2": ch
#import "@preview/unify:0.7.1": num,qty,numrange,qtyrange

#set page(
  paper: "a4",
  margin: (top: 4cm, bottom: 2.5cm, rest: 2cm),
  header-ascent: 2em,

  header: context {
    grid(
      columns: (auto, 1fr),
      align: (top + left, horizon + right),
      image("Diagrams/ubc-banner.svg", height: 5em),
      par(leading: 0.4em)[
        #underline[*CHBE 376:*] *Computer Flowsheeting &\
        Unit Operation Design*
      ],
    )
    v(-1.5em)
    line(length: 100%)
  },

  footer: context {
    if here().page() > 1 {
      line(length: 100%)
      v(-1.5em)
      align(right,
        [
          Page *#counter(page).display("1")* of *#counter(page).final().at(0)*
        ]
      )
    }
  },
)

#set heading(numbering: "1.1.")

#show heading: it => {
  let number = if it.numbering != none {
    numbering(it.numbering, ..counter(heading).at(it.location()))
  }

  let weight = "bold"
  let space  = 0.6em   // consistent gap between number and title for ALL levels

  block(
    above: if it.level == 1 { 1.4em } else { 1.2em },
    below: 1em,
    text(weight: weight)[
      #if number != none {
        box(number)
        h(space)
      }
      #it.body
    ]
  )
}

// ── Counters ──────────────────────────────────────────────────────────────
#let eq-counter  = counter("equation")
#let rxn-counter = counter("reaction")

// Reset equation counter at every new level-1 heading
#show heading.where(level: 1): it => {
  eq-counter.update(0)
  rxn-counter.update(0)
  it
}

// ── Equation with optional label ─────────────────────────────────────────
#let eqn(body, tag: none) = {
  eq-counter.step()
  context {
    let sec = counter(heading).get().at(0)
    let num = eq-counter.get().at(0)
    let label-elem = if tag != none { [#metadata((sec, num))#label(tag)] } else { [] }
    grid(
      columns: (1fr, auto, 1fr),
      align: (left, center + horizon, right + horizon),
      label-elem,
      math.equation(block: true, numbering: none, body),
      [($sec$.$num$)],
    )
  }
}

// ── Reaction with optional label ─────────────────────────────────────────
#let rxn(body, tag: none) = {
  rxn-counter.step()
  context {
    let num = rxn-counter.get().at(0)
    let label-elem = if tag != none { [#metadata(num)#label(tag)] } else { [] }
    grid(
      columns: (1fr, auto, 1fr),
      align: (left, center + horizon, right + horizon),
      label-elem,
      math.equation(block: true, numbering: none, body),
      [(R#num)],
    )
  }
}

// ── Reference helper ─────────────────────────────────────────────────────
#let refeq(tag) = context {
  let data = query(label(tag)).first().value
  [(Eq #data.at(0).#data.at(1))]
}

#let refrxn(tag) = context {
  let num = query(label(tag)).first().value
  [(R#num)]
}

#show figure.where(kind: table): set figure.caption(position: top)
#show figure.where(kind: image): set figure.caption(position: bottom)
#show figure.where(kind: image): set block(width: 100%)

// --- Caption Logic ---
#show figure.caption: it => {
	set align(left)
	set par(leading: 0.9em)
	it
}

#let quote-block(body) = block(
  width: 100%,
  inset: (left: 1em, top: 0.5em, bottom: 0.5em),
  stroke: (left: 3pt + luma(180)),
  body
)

// ── Appendix counter ─────────────────────────────────────────────────────
#let app-counter = counter("appendix")

#let appendix(title) = {
  app-counter.step()
  context {
    let letter = ("A","B","C","D","E","F","G","H","I","J").at(
      app-counter.get().at(0) - 1
    )
    // Fake a level-1 heading so it appears in the TOC
    heading(
      level: 1,
      numbering: none,
      supplement: "Appendix",
      [Appendix #letter: #title]
    )
    eq-counter.update(0)   // reset equation counter, same as normal sections
  }
}

// -- SETUP END --

#set text(font: "Times New Roman", size: 12pt)
#set par(leading: 1.15em, spacing: 2em, justify: true)

#v(2em)
#align(center, text(14pt)[
  *CHBE 376*
])

#v(1em)

#align(center, text(14pt)[
  Instructor: Jonathan Verrett
])

#v(2em)

#align(center, text(18pt)[
  *Term Project - Aniline*
])

#v(3em)

#align(center,
  table(
    stroke: none,
    columns: (auto, auto),
    inset: 10pt,
    align: left + horizon,
    [*Name:*],[*Muhamad Nabil Alhanif*],
    [*Student ID*:],[*76787712*],
    [*Signature:*],[#image("Diagrams/ttd-hitam.png", height: 3cm)]
  )
)

#pagebreak()

#outline()

#pagebreak()

= Process Description

Aniline is a simple primary aromatic amine used for many applications, including polyurethane intermediate, rubber chemicals, and evel rocket fuels @intratecsolutionsllcwww.intratec.usAnilineProductionNitrobenzene2025. The primary way of aniline production is the hydrogenation of nitrobenzene, accounting for 85% of global aniline production @gaoSelectiveCatalyticHydrogenation2023. This process can be carried out in both vapour and liquid phases across a range of different catalysts @gaoSelectiveCatalyticHydrogenation2023. In 2024, the global aniline market is worth 12.3 billion USD and is predicted to grow to 20.4 billion USD by 2033, amounting to around 16.14 million tonnes produced per year @echemiAnilinesGlobalTale2025.

This report will focus on the production of aniline via the liquid-phase catalytic hydrogenation of nitrobenzene. This process is comprised of one reaction, as follows @kahlAniline2011:

#rxn(
  $
    ch("C6H5NO2 + 3 H2 -> C6H5NH2 + 2 H2O")
  $,
  tag: "nitrobenzene-hydrogenation"
)

Reaction 1 is a highly exothermic reaction carried out at $1 - 3$ MPa pressure and $200 - 300 degree C$, combining hydrogen gas with liquid or gas-phase nitrobenzene @gaoSelectiveCatalyticHydrogenation2023@kahlAniline2011. Vapour-phase hydrogenation is selected for this project due to the availability of reaction kinetics data, with the following catalyst composition @rihaniKineticsCatalyticVaporPhase1965:

#list(
  indent: 1em,
  [20% copper plus nickel on asbestos carrier],
  [1:1 copper to nickel ratio],
  [Cadmium in proportion of 15% to copper and nickel]
)

While current Canadian regulations prohibit the use of asbestos @healthcanadaAsbestosYourHealth2012, kinetic data provided by Rihani et al. @rihaniKineticsCatalyticVaporPhase1965 are still in use for this report, due to difficulties in obtaining kinetic data for other catalyst types. Furthermore, it is assumed that other similar copper-nickel catalysts will have similar reaction kinetics.

For the purpose of this report, the nitrobenzene feed used is of technical grade with $99.8$ wt% purity @intratecsolutionsllcwww.intratec.usNitrobenzeneProductionBenzene2025. Similarly, aniline production isi targeted for technical grade with $99.5$ wt% purity @intratecsolutionsllcwww.intratec.usAnilineProductionNitrobenzene2025. The remaining impurity for the feed is assumed to be water, while the remaining impurity for the product is simulated in Aspen.


#pagebreak()
= Block Flow Diagram

@fig:aniline-bfd below shows the starting block flow diagram of this process. This diagram is planned theoretically for use as a guideline for this project. Therefore, it is subject to change based on the analysis done in this report.

#figure(
	image("Diagrams/Aniline Block Diagram.png"),
	caption: [Starting block diagram for the production of aniline from the hydrogenation of nitrobenzene.],
) <fig:aniline-bfd>

#pagebreak()
= Components
The Aniline process is comprised of one reaction shown below.

#rxn(
  $
    ch("C6H5NO2 + 3 H2 -> C6H5NH2 + 2 H2O")
  $,
)

The major components relevant to simulations in this report are listed in @table:main-component below.

#figure(
	caption: [Component names and formulas relevant to the process simulation],
	table(
		stroke: none,
		columns: (1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Component*], 
		[*Formula*],

		table.hline(),

    [Hydrogen],[#ch("H2")],
    [Nitrobenzene],[#ch("C6H5NO2")],
    [Aniline],[#ch("C6H5NH2")],
    [Water],[#ch("H2O")],

		
		table.hline(),
	)
) <table:main-component>

= Property Method

Operating condition for the process lie around $1 - 3$ MPa and $200 - 300 degree C$ @gaoSelectiveCatalyticHydrogenation2023. The reaction species comprise of an amine (aniline) and a nitroaromatic compound (nitrobenzene) in the liquid phase. It also contains hydrogen gas, which is insoluble at atmospheric pressure. Given this, the system would be classified as a chemical system at high pressure. A suitable overall property method would be an activity coefficient model, such as SR-POLAR, SRK, PSRK, or others

#pagebreak()
= Reactor Design

The reactor setup will facilitate the hydrogenation of nitrobenzene in vapour phase via copper-nickel catalysts.

#rxn(
  $
    ch("C6H5NO2 + 3 H2 -> C6H5NH2 + 2 H2O")
  $,
)

Within the reactor, both mass transfer and reaction kinetics affect the reaction rate. In mass transfer, three phases are identified: dissolution of #ch("H2") in the liquid, diffusion of dissolved #ch("H2") and the reactant to the catalyst surface, and intra-particle diffusion to the active sites @duanHydrogenationKineticsHalogenated2022. Mass transfer limitation can be mitigated by increasing temperature, increasing mixing, and reducing catalyst size @frikhaMethodologyMultiphaseReaction2006@liKineticsApproachHydrogenation2011. For simulation purposes, the effect of mass transfer limitation will be ignored.

Our main objective is to produce $100,000$ tonnes of aniline per year, or $1100$ tonne-mol per year, roughly $1\/3$ of the newly operational aniline plant production in 2026 @chemanalystAnilineMarketAnalysis. To start, an overall efficiency of $80%$ is assumed, requiring a feed rate of $1375$ tonne-mol per year. Furthermore, the nitrobenzene feed is assumed to be technical grade ($99.8$ wt% purity), with the remaining impurity being water @intratecsolutionsllcwww.intratec.usNitrobenzeneProductionBenzene2025, and is fed at a 1:5 ratio with hydrogen, providing good conversion while remaining economical @gaoSelectiveCatalyticHydrogenation2023@rihaniKineticsCatalyticVaporPhase1965.

Reaction is simulated in a Plug Flow Reactor (RPLUG) under constant conditions of $1.5$ MPa and $350 degree C$. Reactor size is based on Díaz et al., with a multitube setup comprising 204 tubes, each 12 m long and 0.0978 m in diameter @diazMultiobjectiveOptimizationAniline2022. At the current reactor condition, literature sources suggest conversion between $95 ~ 99.9$%, depending on flowrate and catalyst weight @rihaniKineticsCatalyticVaporPhase1965@diazMultiobjectiveOptimizationAniline2022. As both aniline and nitrobenzene are bulk chemicals, high conversion is important for financial security. Therefore, a minimum $99.5%$ multipass conversion is targeted. Due to limited catalyst information, a generic copper-nickel catalyst physical property is used, yielding a voidage of 0.6 and a bulk density of $1422 " kg/m"^3$ @khanConceptualModelingReactor2023.

#pagebreak()
Kinetic data for the vapour-phase hydrogenation of benzene are taken from Rihani et al @rihaniKineticsCatalyticVaporPhase1965. As is common in Aspen, the catalyst is not accounted for in components, rather being a part of the rate law. The presented powerlaw reaction kinetics is as follows:

$
  r = k dot p_#ch("NB")^0.5 dot p_#ch("H2")^0.5\
  k = 4.104 times 10^4 times e^((-8240)/T)
$

Units are given as:
#list(
  indent: 1em,
  [$r$ = g. moles/hr/g. catalyst],
  [$p$ = atm],
  [$T$ = K]
)

For modelling with Aspen, the above equation must be converted to the following format:
$
  r = k dot e^(-E/(R T)) dot p_#ch("NB")^0.5 dot p_#ch("H2")^0.5
$

Applying conversion gives the following rate constants:
#list(
  indent: 1em,
  [$k = 0.0001125 "kmol"/("sec" dot "kg"_"cat" dot "Pa")$],
  [$E = 68507  "kJ"/"kmol"$]
)

With the reaction kinetics and reactor conditions defined above, the reaction quickly reached 100% conversion with a residence time of 14.73 seconds. The molar composition throughout the whole reactor is shown in @fig:molcomp-initial-reactor below. This indicates that the current reaction conditions work very well, and it might be worth the effort to reduce efficiency and/or residence time to save on operating costs.

#figure(
	image("Diagrams/molar composition for initial reactor setup.png"),
	caption: [Molar composition profile over reactor length.],
) <fig:molcomp-initial-reactor>

#pagebreak()
= Reactor Analysis
From @fig:molcomp-initial-reactor, it is clear that the system is over-designed for the current input and reaction kinetics. This means that parts of the reactor are underutilised, wasting precious resources. Therefore, the main target of this reactor analysis section is to adjust reactor size so that reactants reach their target conversion near the end of their residence time.

== Reactor size

Two reactor size variables are manipulated: length and number of tubes. The analysis are conducted through Aspen's sensitivity analysis, with specification listed in @table:reactor-analysis-spec.

#figure(
	caption: [Sensitivity analysis setup for reactor size],
	table(
		stroke: none,
		columns: (1fr, 1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[],[*Reactor Length*], 
		[*Number of tubes*],
    [],[(m)],[(-)],

		table.hline(),

    [*Lower Bound*],[2],[20],
    [*Upper Bound*],[12],[204],
    [*Increment*],[0.5],[2],
		
		table.hline(),
	)
) <table:reactor-analysis-spec>

Running sensitivity analysis, many size ranges achieve the targeted nitrobenzene conversion. Of these, a final reactor design with a length of $4.5$ metre and $50$ tubes is selected. This configuration is selected as it reached 100% nitrobenzene conversion, reducing separation costs down the line.

== Selected Reactor Specification

The final reactor design is an isothermic reactor with the following specifications:
#list(
  indent: 1em,
  [Temperature: $350 degree C$],
  [Pressure: $1.5$ atm],
  [Length: $4.5$ metres],
  [Number of tubes: $50$]
)


@fig:molcomp-final-reactor below shows the molar composition throughout the reactor. The overall residence time is $1.3$ seconds, roughly $9%$ of the initial residence time. With this setup, complete nitrobenzene conversion is achieved near the reactor outlet, utilising the entire reactor. Stream composition exiting from the reactor is shown in @table:reactor-output-stream.

#figure(
	image("Diagrams/molar composition for final reactor setup.png"),
	caption: [Molar composition profile over reactor length for selected reactor design specifications.],
) <fig:molcomp-final-reactor>

#figure(
	caption: [Stream composition exiting from reactor],
	table(
		stroke: none,
		columns: (1fr, 1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Compound*],[*Mole Flow*], 
		[*Mass Flow*],
    [],[(kmol/hr)],[(kg/hr)],

		table.hline(),

    [Hydrogen],[320.02],[645.12],
    [Nitrobenzene],[Trace],[Trace],
    [Water],[311.62],[5614.01],
    [Aniline],[154.75],[14411.95],
		
		table.hline(),
	)
) <table:reactor-output-stream>

#pagebreak()
= Column Design <ch:column-design>
As the specified reactor design achieved an overall nitrobenzene conversion of $100%$, only two separation steps are needed: to remove excess hydrogen gas, and purify aniline from water. @table:compound-boiling-point compares the different boiling points of compounds involved in this process.

#figure(
	caption: [Comparison of boiling points of compounds involved in aniline production],
	table(
		stroke: none,
		columns: (1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Compound*],[*Boiling Point*],
    [],[($degree C$)],

		table.hline(),

    [Hydrogen],[-259.16 @Hydrogen2024],
    [Nitrobenzene],[210.8 @pubchemNitrobenzene],
    [Water],[100 @pubchemWater],
    [Aniline],[184.1 @pubchemAniline],
		
		table.hline(),
	)
) <table:compound-boiling-point>

== Separation 1: Hydrogen Recycle

Hydrogen has a critical temperature of $-240.2 degree C$, far lower than the operating reactor temperature @Hydrogen2024. Due to this, hydrogen is considered to be incondensable at this state; it can't be liquefied by changing pressure @elliotChapter1Basic2012. Therefore, the two streams coming out of this block are a vapour-phase hydrogen stream and a liquid-phase water-aniline mixture. In a later section of this report, the hydrogen stream is recycled back into the reactor. However, for simplicity, the hydrogen stream is treated as a waste stream during initial simulation of this separation step.

Due to the large boiling point difference between hydrogen to water and aniline, a simple flash chamber can be used to complete this separation. Because compounds tend to condense more readily at higher pressure, this flash chamber is operated at the same pressure as the reactor, at $1.5$ MPa. As hydrogen is non-condensable, the flash temperature is set below the bubble point of a water-aniline mixture. From binary simulation in Aspen, water and aniline form a vapour-liquid-liquid equilibrium, with the mixture forming a liquid-liquid equilibrium below $195 degree C$.

#figure(
	caption: [Initial separation results from flash chamber operating at $1.5$ MPa and $195 degree C$],
	table(
		stroke: none,
		columns: (1fr, 1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Compound*],[*Distillate Mole Flow*], 
		[*Bottom Mole Flow*],
    [],[(kmol/hr)],[(kmol/hr)],

		table.hline(),

    [Hydrogen],[319.49],[0.53],
    [Nitrobenzene],[Trace],[Trace],
    [Aniline],[295.57],[16.05],
    [Water],[60.73],[94.02],
		
		table.hline(),
	)
) <table:initial-flash-chamber-composition>

Operating at $1.5$ MPa and $195 degree C$, @table:initial-flash-chamber-composition above shows the stream mole flow achieved by the flash separation. Less than $63%$ of the aniline produced is recovered, indicating that this initial operating condition is not ideal.

== Separation 2: Aniline Purification

The second separation of this process is focused on purifying aniline to achieve the targeted technical grade purity of $99.5$ wt% @intratecsolutionsllcwww.intratec.usAnilineProductionNitrobenzene2025. For the initial setup of the column, it is assumed that separation 1 was completed successfully, resulting in the stream composition shown in @table:stream-to-separation2, at $1.5$ MPa and $195 degree C$. This composition is a rough estimate and does differ from the actual stream composition. It will be revised in a later section after completion of the analysis for separation 1.

#figure(
	caption: [Rough stream composition estimate entering separation 2],
	table(
		stroke: none,
		columns: (1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Compound*],[*Mole Flow Entering Separation 2*],
    [],[(kmol/hr)],

		table.hline(),

    [Hydrogen],[1],
    [Nitrobenzene],[0],
    [Water],[310],
    [Aniline],[154],
		
		table.hline(),
	)
) <table:stream-to-separation2>

As the aniline-water mixture forms a liquid-liquid equilibrium, feeding this stream directly into a DSTWU proves problematic, resulting in negative minimum reflux and feed stage. For this reason, a liquid-liquid extraction technique is performed. It is for the same reason that the property method is changed to UNIFAC with Henry's Components for this separation stage; UNIFAC models non-ideal liquid-liquid interaction much better than PSRK @al-malahLiquidLiquidExtraction2017.

In a liquid-liquid extraction process, a solvent is used to transfer the solute (in this case, aniline) from one liquid phase to another. The remaining liquid, low on solute, is called the diluent and is disposed of @wankatChapter13LiquidLiquid. For this process, heptane is selected as the solvent, as it has previously been successfully used for
aniline purification @frankSection15LiquidLiquid2008@charlesLiquidliquidEquilibriumData1957.

For initial setup, an adiabatic Extract column with 10 stages is used. The column is operating at $0.1$ MPa, reducing the need to pressurise feed, saving operating costs. Water is the key component of the $1^"st"$ liquid phase, while heptane is the key component of the $2^"nd"$ liquid phase. Heptane is fed at $150$ kmol/hr into the column from the bottom going up. Aniline-water mix is coming into the column from the top going down. Thus, the column is operating in counter-current. The heavier water is recovered from the raffinate, while the aniline-heptane mix is recovered from the extract and transferred to a second distillation column to further purify the aniline.

#figure(
	caption: [Liquid liquid extraction result for estimate stream],
	table(
		stroke: none,
		columns: (1fr, 1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Compound*],[*Extract Mole Flow*], 
		[*Raffinate Mole Flow*],
    [],[(kmol/hr)],[(kmol/hr)],

		table.hline(),

    [Hydrogen],[1],[Trace],
    [Nitrobenzene],[0],[0],
    [Aniline],[154],[Trace],
    [Water],[47.69],[262.31],
    [Heptane],[149.99],[0.01],
		
		table.hline(),
	)
) <table:LL-result-estimate-stream>

From @table:LL-result-estimate-stream, it is clear that the extract stream needs another distillation step to obtain technical grade aniline. To obtain an initial estimate of the column, a DSTWU is used before performing a more rigorous simulation with RadFrac. The column is operating at $0.1$ MPa condenser and reboiler pressure, with a partial reboiler with all vapour distillate. Reflux ratio is set at $1.35$ times the minimum reflux. Heptane boiling point is $98 degree C$, lower than water @pubchemHeptane. As such, water is the light key, with an initial recovery guess of $0.99$. Similarly, aniline is the heavy key with an initial recovery guess of $0.01$. This recovery value will be iterated upon during later analysis to achieve the target aniline purity.

#pagebreak()
Running the simulation with the aforementioned specification throws the following error in Aspen:

#quote-block[
  \*\* ERROR\
  #h(1em) MINIMUM REFLUX RATIO CALCULATED FROM UNDERWOOD EQUATION\
  #h(1em) IS -0.78951. REFLUX RATIO RESET TO 0.1.
]

Due to this error, the reflux ratio profile can't be generated, and analysis must be conducted directly on
the RadFrac column. However, the simulation still produces a feasible design summary:
#list(
  indent: 1em,
  [Actual reflux ratio: $0.135$],
  [Actual number of stages: $8$],
  [Feed stage: $2$],
  [Distillate to feed ratio: $0.562$]
)

These values are used as an initial design specification for a RadFrac column with a partial condenser with all vapour distillate. Due to the potential existence of a liquid-liquid equilibrium region, the 3- Phase option is enabled and tested for all equilibrium stages. Internal stages have an assumed efficiency of $80%$, while the condenser and reboiler are assumed to be 100% efficient, as components are condensing or vapourising @verrettCHBE3762025W.

#figure(
	caption: [Output stream of RadFrac simulation for aniline purification],
	table(
		stroke: none,
		columns: (1fr, 1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Compound*],[*Distillate Mole Flow*], 
		[*Bottom Mole Flow*],
    [],[(kmol/hr)],[(kmol/hr)],

		table.hline(),

    [Hydrogen],[1],[Trace],
    [Nitrobenzene],[0],[0],
    [Aniline],[154],[Trace],
    [Water],[47.69],[262.31],
    [Heptane],[149.99],[0.01],
		
		table.hline(),
	)
) <table:initial-radfrac-result>

@table:initial-radfrac-result the stream composition of RadFrac's outlets. In the bottom stream, aniline has a purity of $97.7$ wt%, lower than the targeted $99.5$ wt%. Increasing this final purity is one of the analysis targets later.

#pagebreak()
= Column Analysis

From @ch:column-design above, it is clear that the initial separator design are inefficient. In this section, three analysis are conducted: aniline & water recovery, hydrogen recycle, and aniline purification.

== Aniline & Water Recovery

The initial flash chamber design was inefficient, as it recovered only 60% of the aniline produced. To increase the recovery rate, operating temperature of the chamber is varied from $0 - 200 degree C$ at $5 degree C$ intervals using sensitivity analysis.

#figure(
	image("Diagrams/fractional recovery aniline by temperature.png"),
	caption: [Fractional recovery of aniline and water from flash chamber by varying temperature],
) <fig:aniline-fr-by-temperature>

@fig:aniline-fr-by-temperature above compares the fractional recovery of aniline and water as a result of varying temperature. $50 degree C$ is selected because both water and aniline have bottom recovery above 99%, at 99% for water and $99.9%$ for aniline. This has an added benefit of the ability to use cooling water for flashing, one of the most economical utility options @kimCoolingWaterSystem2001. The resulting stream is shown in @table:final-flash-chamber-result.

#figure(
	caption: [Stream composition exiting flash chamber at $50 degree C$, $1.5$ MPa without recycle],
	table(
		stroke: none,
		columns: (1fr, 1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Compound*],[*Distillate Mole Flow*], 
		[*Bottom Mole Flow*],
    [],[(kmol/hr)],[(kmol/hr)],

		table.hline(),

    [Hydrogen],[318.7],[1.31],
    [Nitrobenzene],[Trace],[Trace],
    [Aniline],[0.09],[154.67],
    [Water],[2.87],[308.76],
		
		table.hline(),
	)
) <table:final-flash-chamber-result>

== Hydrogen Recycle

Ideally, the vapour stream exiting from the flash chamber is recycled back into the reactor to improve process efficiency. It is desired that nitrobenzene and hydrogen be fed to the reactor at a $1:5$ ratio after being mixed with the recycle stream. For process safety and to remove impurities, a splitter to purge stream is added to facilitate gas release. This makes the molar flow rate of recycled hydrogen variable, especially during the design step when the split fraction is not finalised. Therefore, a calculator block is needed to determine the amount of raw hydrogen feed needed to maintain this ratio.

To analyse the impact of the splitting fraction, sensitivity analysis is used. The varied variable is the splitter split fraction, varied from $0.05$ to $0.95$ with an interval of $0.05$. @fig:aniline-fr-by-recycle-stream shows the nitrobenzene conversion and fractional recovery of aniline from varying recycled split fractions. There are no noticeable differences in the measured variable, likely due to the calculator block keeping a constant feed ratio to the reactor. Hence, the selected recycled split fraction is $0.8$, maximising hydrogen feed while keeping a purge line open to remove impurity. Flashing results are shown in @table:final-flash-chamber-result-recycle.

#figure(
	image("Diagrams/impact of recycle stream fraction on conversion and FR.png"),
	caption: [Impact of recycle stream split fraction on nitrobenzene conversion and fractional recovery of aniline from flash chamber],
) <fig:aniline-fr-by-recycle-stream>

#figure(
	caption: [Stream composition exiting flash chamber at $50 degree C$, $1.5$ MPa with recycle],
	table(
		stroke: none,
		columns: (1fr, 1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Compound*],[*Distillate Mole Flow*], 
		[*Bottom Mole Flow*],
    [],[(kmol/hr)],[(kmol/hr)],

		table.hline(),

    [Hydrogen],[308.12],[1.32],
    [Nitrobenzene],[Trace],[Trace],
    [Aniline],[0.09],[154.74],
    [Water],[2.77],[311.07],
		
		table.hline(),
	)
) <table:final-flash-chamber-result-recycle>

== Aniline Purification

The initial aniline purification setup defined in @ch:column-design has three main shortcomings. First, the feed stream is only an estimate and is not connected to the flash chamber. Second, the heptane solvent flow rate to liquid-liquid extraction column is also an estimate and might not be optimal. Third, mass purity for aniline is lower than desired. In this analysis section, the liquid-liquid extraction column will be connected to the flash chamber, taking its bottom stream (@table:final-flash-chamber-result-recycle) as the top feed. As mentioned in @ch:column-design, the property method for this column is UNIFAC with Henry's Components.

To improve mass purity, several variables can be manipulated: heptane molar flow, RadFrac reflux ratio, and RadFrac distillate-to-feed (D/F) ratio. Reflux ratio is kept at $0.135$ to avoid instability issues, as seen in the previous DSTWU error. To analyse the impact of heptane molar flow and D/F ratio on aniline purity and recovery, sensitivity analysis are used.

Each variables are first analysed separately. On the heptane molar flow rate, increasing values initially result in higher RadFrac recovery before reaching an inflexion point around $125$ kmol/hr heptane. This is likely caused by the heptane saturating the RadFrac column and “bleeds” into the distillate stream. This theory is supported by the aniline mass fraction in RadFrac distillate, decreasing as the heptane flow rate increases. For liquid-liquid aniline recovery, a higher heptane flow rate results in a higher recovery, reaching $100%$ at $100$ kmol/hr heptane. For the D/F ratio, a higher ratio results in a higher aniline mass fraction but a lower recovery. This is shown in @fig:impact-heptane-to-fr and @fig:impact-radfrac-to-fr.

#figure(
	image("Diagrams/impact of heptane flowrate to recovery.png"),
	caption: [Impact of heptane molar flow rate to aniline recovery and mass fraction],
) <fig:impact-heptane-to-fr>

#figure(
	image("Diagrams/impact of radfrac to recovery.png"),
	caption: [Impact of RadFrac D/F ratio on aniline recovery and mass fraction],
) <fig:impact-radfrac-to-fr>

Based on the observations above, there appears to be a sweet spot between heptane molar flow rate and D/F ratio producing high purity aniline with good recovery. To find this, a third sensitivity analysis is devised, varying the heptane flow rate between $115$ and $150$ kmol/hr and the D/F ratio between $0.35$ and $0.55$.

The final selected specification is $100$ kmol/hr heptane molar flow rate and 0.51 RadFrac D/F ratio. At this condition, aniline output is of $99.7$ wt% purity and recovery in RadFrac column is $98.1%$. Final stream composition is listed in @table:final-separation-result.

#figure(
	caption: [Final stream composition leaving RadFrac distillation column],
	table(
		stroke: none,
		columns: (1fr, 1fr, 1fr),
    inset: 0.5em,

		table.hline(),

		// Header Row 1
		table.cell[*Compound*],[*Distillate Mole Flow*], 
		[*Bottom Mole Flow*],
    [],[(kmol/hr)],[(kmol/hr)],

		table.hline(),

    [Hydrogen],[1.32],[Trace],
    [Nitrobenzene],[Trace],[Trace],
    [Aniline],[2.89],[151.85],
    [Water],[54.78],[Trace],
    [Heptane],[99.53],[0.45],
		
		table.hline(),
	)
) <table:final-separation-result>

#pagebreak()
= Heat Exchanger Design

To separate and recycle excess hydrogen, the reactor product stream is cooled down to $50 degree C$ prior to entering the flash block for separation. Reactor product stream is exiting at $350 degree C$, with composition shown in @table:reactor-output-stream. The utility used to perform this cooling is cooling water at $20 degree C$, recovered at $95 degree C$ at $1$ atm while still in the liquid phase.

The required cooling water flow is determined using a HEATER block, requiring $111$ tonnes/hr in total. Heat exchanger design calculations are then performed using a HEATX block, with a pure water feed at $20 degree C$ fed into the cold inlet at a flow rate of $111$ tonnes/hr. Reactor product stream is fed to the hot inlet, and is flown in the tube side due to its higher pressure @enerquipTubeSideShell2025. The HEATX block uses the shortcut model with a countercurrent direction to maximise heat transfer. The hot outlet stream is specified at $50 degree C$. With this configuration, the vapour and condensing phases are present on the hot side, while only the liquid phase is present on the cold side, as shown in Figure 8.

#figure(
	image("Diagrams/vapour fraction in heatx.png"),
	caption: [Vapour fraction of hot and cold side in HEATX heat exchanger],
) <fig:vapour-fraction-heatx>

Overall heat transfer coefficients ($U$) for the components present are estimated as average from literature values @HeattransferEquipment. The hot side is taken as organics with some non-condensable as aniline is an organic compound. Overall heat transfer coefficient between vapour hot side with liquid water is $500 " W/m"^2"-"degree C$, while coefficient between condensing hot side with liquid water is $600 " W/m"^2"-"degree C$. In this configuration, the needed heat exchanger area is $197.95 " m"^2$. This large area requirement indicates the possibility that a multipass heat exchanger might work better than singlepass countercurrent.

#pagebreak()
= Heat Exchanger Analysis

Sensitivity analysis are used to investigate the impact of overall heat transfer coefficient estimate on heat exchanger area. As there are two coefficient used in this simulation, they are assessed separately, with a final assessment to analyse the best and worse case scenarios.

== Vapour Hot Side - Liquid Cold Side

In this analysis, the heat transfer coefficient for vapour hot side - liquid cold side is varied from $250 - 750 " W/m"^2"-"degree C$, while keeping the condensing heat transfer coefficient constant @HeattransferEquipment. In Aspen, this is the V-L block variable. As a result, the heat exchanger area varies between $215.5 " m"^2$ and $192.1 " m"^2$, a change of $8.9%$ and $-3%$ respectively. This shown in @fig:VL-heatx.

#figure(
	image("Diagrams/heatx area on VL U.png"),
	caption: [Heat exchanger area on different vapour hot side - liquid cold side heat transfer coefficient],
) <fig:VL-heatx>


== Condensing Hot Side - Liquid Cold Side
Heat transfer coefficient for condensing hot side - liquid cold side is varied between $500 - 700 " W/m"^2"-"degree C$, while keeping the V-L heat transfer coefficient constant. In Aspen, this is the B-L variable. As a result, the heat exchanger area varies between $234 " m"^2$ - $172.2 " m"^2$, a change of 1$8.2%$ and $-13%$ respectively. This is shown in @fig:CL-heatx, with a more linear curve compared to @fig:VL-heatx.

#figure(
	image("Diagrams/heatx area on CL U.png"),
	caption: [Heat exchanger area on different condensing hot side - liquid cold side heat transfer coefficient],
) <fig:CL-heatx>

== Overall Assessment

The best and worst case scenarios for the heat exchanger area are assessed using both ends of the heat transfer coefficient range. For the best case scenario, V-L and C-L have coefficients of $750 " W/m"^2"-"degree C$ and $700 " W/m"^2"-"degree C$, respectively. This results in $166.32 " m"^2$. For the worst case scenario, V-L and C-L have coefficients of $250 " W/m"^2"-"degree C$ and $500 " W/m"^2"-"degree C$, respectively, resulting in $251.62 " m"^2$.

Overall, heat exchangers are reduced by $16%$ in the best case, and increased by $27%$ in the worst case. This large difference signifies the importance of having accurate heat transfer coefficient measurements. Furthermore, the C-L heat transfer coefficient has a larger impact on the final heat exchanger area, and thus must be prioritised when searching for data or conducting experiments.

#pagebreak()
= Discussion / Reflection

This report successfully demonstrated unit operation design for the production of 99.5 wt% pure aniline via the hydrogenation of nitrobenzene. The final completed flowsheet is shown in @fig:final-flowsheet.

Throughout the process, there were a number of challenges and assumptions made in setting up the simulation. The largest assumption is that only 1 reaction, #refrxn("nitrobenzene-hydrogenation"), happens in the reactor, and that no reaction occurs elsewhere. While selectivity and conversion are generally very high (close to $100%$) @gaoSelectiveCatalyticHydrogenation2023, the hydrogenation reaction is actually comprised of many branching intermediate reactions which may not have perfect selectivity @coutoHydrogenationNitrobenzenePd2015.

One of the main challenges faced in this project is in finding reaction kinetics data. The availability of this data is sparse, and limitation of Aspen makes it harder in finding suitable data. The current data in used is old, released in 1965. Furthermore, the catalyst described by the paper is no longer in use due to health concerns @healthcanadaAsbestosYourHealth2012. While newer kinetics data with better catalyst are available, the Langmuir-Hinshelwood-Hougen-Watson (LHHW) kinetics they described is too complex for Aspen, as it has both pressure and concentration terms @turakovaLiquidPhaseHydrogenation2015@brovkoEvaluationNitrobenzeneHydrogenation2021.

Another limitation is the lack of pressure simulation. Throughout the process, pressure drop is assumed negligible, with big pressure changes happening within an operational unit. This is not representative of a real world system where pressure drop happens due to internal piping and equipment resistance @husseinChapter2Flow2023.

#pagebreak()
#set page(flipped: true)
#figure(
	image("Diagrams/final flowsheet.png"),
	caption: [Completed flowsheet for aniline production via hydrogenation of nitrobenzene],
) <fig:final-flowsheet>
#set page(flipped: false)


#pagebreak()
= Next Steps

For future iteration of this report, side reactions and intermediary should be simulated for accuracy. If possible, the powerlaw reaction kinetic should be replaced with a more accurate LHHW kinetic by the use of CALCULATOR blocks.

Furthermore, pressure drop and changes throughout the system must be analysed. Heat exchanger should be rewired to optimise heat transfer, i.e., by using reactor effluent to heat up feed and recycle stream. 

Specific liquid-liquid extraction technique should also be investigated; if needed, simulations can be conducted via SEP and CALCULATOR blocks. Finally, regeneration of heptane post-LL extraction should be looked into.

#pagebreak()

#show bibliography: set heading(numbering: "1.")
#bibliography("ref.bib")

#pagebreak()
#appendix[Rate Constants Conversion]

#image("Diagrams/rate constants conversion.jpeg")