import pandas as pd

security = pd.read_csv(
    r"C:\Users\User\Desktop\Security.csv"
)

security.to_sql(
    "security",
    con=engine,
    if_exists="replace",
    index=False
)

print("Created table: security")
