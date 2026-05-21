import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from app.database import engine, Base
from app import models
from sqlalchemy import text

def recreate_tables():
    """Recreate all tables in the database"""
    try:
        print("Disabling foreign key checks...")
        with engine.connect() as conn:
            conn.execute(text("SET FOREIGN_KEY_CHECKS = 0"))
            conn.commit()
        print("✓ Foreign key checks disabled")
        
        print("Dropping all existing tables...")
        Base.metadata.drop_all(bind=engine)
        print("✓ Tables dropped")
        
        print("Enabling foreign key checks...")
        with engine.connect() as conn:
            conn.execute(text("SET FOREIGN_KEY_CHECKS = 1"))
            conn.commit()
        print("✓ Foreign key checks enabled")
        
        print("Creating new tables...")
        Base.metadata.create_all(bind=engine)
        print("✓ Tables created successfully")
        
        return True
    except Exception as e:
        print(f"✗ Error: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    recreate_tables()
