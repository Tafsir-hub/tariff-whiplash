# Build plan

## Today (about 2 hours)
- [ ] Create a public GitHub repo named `tariff-whiplash` and upload this folder.
- [ ] Request a free Census API key (link in README). It arrives by email.
- [ ] Install Python packages: `pip install requests pandas`
- [ ] Test one small pull: `python scripts/fetch_census.py --start 2026-01 --end 2026-01`
- [ ] Open the CSV in Excel and check: countries, HS chapters, values look sensible.
- [ ] Review `data/policy_events.csv`; confirm or correct each row marked `verify`.

## Week 1: Data
- [ ] Pull full range (Jan 2024 to latest month) for both datasets.
- [ ] Create MySQL database, run `sql/01_schema.sql`, load CSVs.
- [ ] Check row counts and totals against Census's published monthly totals.

## Week 2: Analysis
- [ ] Run and refine `sql/02_analysis.sql`.
- [ ] Export result tables to `data/processed/` for Tableau.
- [ ] Write down 3–4 findings in plain sentences, with numbers.

## Week 3: Dashboard
- [ ] Page 1 Timeline: monthly import value with policy events marked.
- [ ] Page 2 Sourcing shift: China vs. Vietnam, Mexico, India, Taiwan, others.
- [ ] Page 3 Products: biggest movers by HS chapter.
- [ ] Page 4 Ports + effective duty rate.
- [ ] Publish to Tableau Public; add link to README and resume.

## Week 4: Polish
- [ ] Add screenshots and findings to README.
- [ ] Short LinkedIn post with one chart and one finding.
- [ ] Add GitHub + Tableau links to resume.
