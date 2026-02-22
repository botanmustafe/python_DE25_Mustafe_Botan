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


# läser in json-filen till semikolon-separerad data

def load_products(path: Path) -> pd.DataFrame:
    return pd.read_csv(path, sep=";", dtype=str)


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
# “Extremt höga priser” = topp 5%

    valid_prices = df.loc[df["price"].notna() & df["price"].ge(0), "price"]

    if len(valid_prices) >= 10:
        upper = valid_prices.quantile(0.95)  # 95:e percentilen
        df["flag_extreme_price"] = df["price"].gt(upper)
        df["extreme_price_limit"] = float(upper)
    else:
        df["flag_extreme_price"] = False
        df["extreme_price_limit"] = pd.NA


# enkla regler för "omöjliga" värden (det som gör att en rad avvisas)

    currency_ok = df["currency"].isin(ALLOWED_CURRENCIES)
    id_ok = df["id"].notna() & (df["id"].astype(str).str.strip() != "")
    name_ok = df["name"].notna() & (df["name"].astype(str).str.strip() != "")
    price_ok = df["price"].notna() & df["price"].ge(0)

 # avvisa om någon av grundreglerna inte är uppfylld

    df["is_rejected"] = ~(currency_ok & id_ok & name_ok & price_ok)

    return df


def write_outputs(df: pd.DataFrame) -> None:

# skapa output-mappen om den inte finns

    OUTPUT_DIR.mkdir(exist_ok=True)

    accepted = df.loc[~df["is_rejected"]].copy()

 # behåll bara rader som inte avvisatsc
    summary = pd.DataFrame([{
        "snittpris": float(accepted["price"].mean()) if len(accepted) else pd.NA,
        "medianpris": float(accepted["price"].median()) if len(accepted) else pd.NA,
        "antal produkter": int(len(accepted)),
        "antal produkter med saknat pris": int(df["flag_missing_price"].sum()),
    }])

    # spara csv-filen i output
    summary.to_csv(OUTPUT_DIR / "analytics_summary.csv", index=False)


def main() -> None:
      
    # kontrollera att filen finns innan vi kör
    if not INPUT_FILE.exists():
        raise FileNotFoundError(
            f"Hittar inte {INPUT_FILE}. Lägg products.json i projektroten.")


    #ingest: läs in data
    #transform: rensa, flagga, avvisa
    #access: skapa output-fil
    df = load_products(INPUT_FILE)
    df = add_flags(df)
    write_outputs(df)

    print("Klart! Skapade filer i ./output/")
    print("- analytics_summary.csv")


if __name__ == "__main__":
    main()
