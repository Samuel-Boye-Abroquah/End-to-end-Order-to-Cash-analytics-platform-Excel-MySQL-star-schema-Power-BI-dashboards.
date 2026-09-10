# -----------------------------------------------------------------------------
# load_excel.py
#
# Reads every sheet from the Meridian Office & Tech Supply Co. workbook
# and writes each sheet to a MySQL table.
#
# Table naming: sheet name lowercased, spaces replaced with underscores.
#   "Orders_2022"    -> orders_2022
#   "OrderLines_2022" -> orderlines_2022
#   "Products"        -> products
#
# Run:
#   python load_excel.py
#
# Before running: replace <YOUR_PASSWORD> below with your real MySQL password.
# Do NOT commit the real password to git.
# -----------------------------------------------------------------------------

import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    "mysql+pymysql://BigSam:<YOUR_PASSWORD>@localhost:3306/Meridian_OfficeSupply_OrderToCash_2022_2025"
)

file = r"C:\ProgramData\MySQL\MySQL Server 8.0\Uploads\Meridian_OfficeSupply_OrderToCash_2022-2025.xlsx"

sheets = pd.read_excel(file, sheet_name=None)

for sheet_name, df in sheets.items():
    table_name = sheet_name.lower().replace(" ", "_")

    df.to_sql(
        table_name,
        con=engine,
        if_exists="replace",
        index=False
    )

    print(f"Created table: {table_name}")
