import os

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

MYSQL_HOST     = os.getenv("MYSQLHOST",     "localhost")
MYSQL_PORT     = os.getenv("MYSQLPORT",     "3306")
MYSQL_USER     = os.getenv("MYSQLUSER",     "root")
MYSQL_PASSWORD = os.getenv("MYSQLPASSWORD", "")
MYSQL_DATABASE = os.getenv("MYSQL_DATABASE", "spk_knn")

DATABASE_URL = (
    f"mysql+pymysql://{MYSQL_USER}:{MYSQL_PASSWORD}"
    f"@{MYSQL_HOST}:{MYSQL_PORT}/{MYSQL_DATABASE}"
)

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()