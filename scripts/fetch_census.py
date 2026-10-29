"""
Pull monthly U.S. import data from the Census International Trade API.

Usage:
    python scripts/fetch_census.py --start 2024-01 --end 2026-08
Set your key first:  export CENSUS_API_KEY=your_key   (Windows: set CENSUS_API_KEY=your_key)

Outputs (data/raw/):
    imports_country_hs2.csv  monthly imports by country x HS chapter (value + calculated duty)
    imports_port_hs2.csv     monthly imports by U.S. port x HS chapter (total + containerized value)
"""
import argparse, os, time
import pandas as pd
import requests

BASE = "https://api.census.gov/data/timeseries/intltrade/imports"
KEY = os.environ.get("CENSUS_API_KEY", "")

DATASETS = {
    "imports_country_hs2.csv": {
        "endpoint": "hs",
        "get": "CTY_CODE,CTY_NAME,I_COMMODITY,I_COMMODITY_SDESC,GEN_VAL_MO,CON_VAL_MO,CAL_DUT_MO",
    },
    "imports_port_hs2.csv": {
        "endpoint": "porths",
        "get": "PORT,PORT_NAME,I_COMMODITY,GEN_VAL_MO,CNT_VAL_MO,CNT_WGT_MO",
    },
}

def months(start, end):
    return [p.strftime("%Y-%m") for p in pd.period_range(start, end, freq="M")]

def fetch(endpoint, get, month):
    params = {"get": get, "COMM_LVL": "HS2", "time": month}
    if KEY:
        params["key"] = KEY
    r = requests.get(f"{BASE}/{endpoint}", params=params, timeout=120)
    if r.status_code == 204 or not r.text.strip():
        return None  # month not published yet
    r.raise_for_status()
    rows = r.json()
    df = pd.DataFrame(rows[1:], columns=rows[0])
    df = df.loc[:, ~df.columns.duplicated()]  # API repeats predicate columns
    return df

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--start", default="2024-01")
    ap.add_argument("--end", default=pd.Timestamp.today().strftime("%Y-%m"))
    a = ap.parse_args()
    out_dir = os.path.join(os.path.dirname(__file__), "..", "data", "raw")
    os.makedirs(out_dir, exist_ok=True)

    for fname, cfg in DATASETS.items():
        frames = []
        for m in months(a.start, a.end):
            df = fetch(cfg["endpoint"], cfg["get"], m)
            if df is None:
                print(f"{cfg['endpoint']} {m}: no data yet, skipping")
                continue
            print(f"{cfg['endpoint']} {m}: {len(df):,} rows")
            frames.append(df)
            time.sleep(0.5)  # be polite to the API
        if frames:
            out = pd.concat(frames, ignore_index=True)
            out.to_csv(os.path.join(out_dir, fname), index=False)
            print(f"Saved {fname}: {len(out):,} rows")

if __name__ == "__main__":
    main()
