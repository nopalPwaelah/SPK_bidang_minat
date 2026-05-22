import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

MYSQL_HOST = os.getenv("MYSQLHOST", "localhost")
MYSQL_PORT = os.getenv("MYSQLPORT", "3306")
MYSQL_USER = os.getenv("MYSQLUSER", "root")
MYSQL_PASSWORD = os.getenv("MYSQLPASSWORD", "")
MYSQL_DATABASE = os.getenv("MYSQLDATABASE", "spk_knn")  # ← diperbaiki

DATABASE_URL = (
    f"mysql+pymysql://"
    f"{MYSQL_USER}:{MYSQL_PASSWORD}"
    f"@{MYSQL_HOST}:{MYSQL_PORT}"
    f"/{MYSQL_DATABASE}"
)

print("DB URL:", DATABASE_URL)

engine = create_engine(engine_url := DATABASE_URL)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine,
)

Base = declarative_base()