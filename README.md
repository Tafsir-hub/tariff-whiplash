# Tariff Whiplash: How U.S. Trade Policy Reshaped Import Flows (2024–2026)

**Status:** In progress, started October 2026
**Tools:** Python · MySQL · SQL · Tableau Public
**Dashboard:** _link coming soon_

## The question
Between 2025 and 2026, U.S. tariff policy changed again and again: new tariffs, pauses,
court rulings, and replacement tariffs. This project measures what those changes did
to U.S. imports, using official monthly U.S. Census Bureau trade data.

## Business questions
1. **Timing:** Did importers rush shipments in before tariff deadlines, and drop off after?
2. **Sourcing:** How much did China's share of U.S. imports fall, and which countries gained?
3. **Products:** Which product categories (HS chapters) moved the most?
4. **Cost:** How did the effective duty rate (duties paid ÷ import value) change by country?
5. **Ports:** Which U.S. ports gained or lost containerized import value?

## Data
| Source | What it gives | Endpoint |
|---|---|---|
| U.S. Census Bureau, International Trade API | Monthly imports by country and HS code, incl. calculated duty | `timeseries/intltrade/imports/hs` |
| U.S. Census Bureau, International Trade API | Monthly imports by U.S. port, incl. containerized vessel value | `timeseries/intltrade/imports/porths` |
| `data/policy_events.csv` (hand-built) | Dated tariff and policy events for chart annotations | — |

All data is public. A free Census API key is recommended: https://api.census.gov/data/key_signup.html

## Project structure
```
data/raw/            raw API pulls (not committed if large)
data/processed/      cleaned CSVs loaded into MySQL / Tableau
data/policy_events.csv
scripts/fetch_census.py   pulls monthly data from the Census API
sql/01_schema.sql         MySQL tables + CSV loading
sql/02_analysis.sql       analysis queries behind each dashboard page
tableau/             Tableau workbook + screenshots
docs/PLAN.md         build plan
```

## Key findings
_To be added once the analysis is done (3–4 short, numbered findings)._

## Author
Mohamed Tafsir Yattara · linkedin.com/in/tafsir-yattara
