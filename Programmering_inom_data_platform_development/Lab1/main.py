# installera verktyg samt paths

from __future__ import annotations
from pathlib import Path
import pandas as pd

# filvägar

INPUT_FILE = Path("products.json")
OUTPUT_DIR = Path("output")

# tillåtna valutor
# går att utöka på labbfilen med olika valutor
ALLOWED_CURRENCIES = {"SEK", "EUR", "USD"}


# läser in json till en dataframe

def load_products(path: Path) -> pd.DataFrame:

    try:
        df = pd.read_json(path)
    except ValueError:
        import json
        raw = json.loads(path.read_text(encoding="utf-8"))
        df = pd.json_normalize(raw)

    return df

   

def add_flags(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()

      # säkerställ kolumner (om någon saknas, skapa den)

    for col in ["id", "name", "price", "currency"]:
        if col not in df.columns:
            df[col] = pd.NA

    # konvertera pris till numeriskt (icke numeriska blir NaN)
    df["price"] = pd.to_numeric(df["price"], errors="coerce")

   
    # skapa flaggor för eventuella dataproblem
     # avvisa vissa omöjliga värden

    df["flag_missing_currency"] = df["currency"].isna() | (
        df["currency"].astype(str).str.strip() == "")
    df["flag_missing_price"] = df["price"].isna()
    df["flag_price_zero"] = df["price"].fillna(0).eq(0)
    df["flag_negative_price"] = df["price"].fillna(0).lt(0)

    
# flaggning för extremt höga priser
# “Extremt höga priser” topp 5%


    valid_prices = df.loc[df["price"].notna() & df["price"].ge(0), "price"]

    if len(valid_prices) >= 10:
        upper = valid_prices.quantile(0.95)  # 95:e percentilen
        df["flag_extreme_price"] = df["price"].gt(upper)
        df["extreme_price_limit"] = float(upper)
    else:
        df["flag_extreme_price"] = False
        df["extreme_price_limit"] = pd.NA



        