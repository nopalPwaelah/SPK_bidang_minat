import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from app.database import SessionLocal
from app.models import User
from app.auth import hash_password

def create_default_users():
    """Create default admin and user accounts"""
    db = SessionLocal()
    
    try:
        # Check if admin already exists
        admin = db.query(User).filter(
            User.email == "admin@gmail.com"
        ).first()
        
        if admin:
            print("✓ Admin user already exists")
        else:
            admin_user = User(
                username="Admin",
                email="admin@gmail.com",
                password=hash_password("admin123"),
                role_id=1  # 1 = Admin
            )
            db.add(admin_user)
            print("✓ Admin user created: admin@gmail.com / admin123")
        
        # Check if regular user exists
        user = db.query(User).filter(
            User.email == "user@gmail.com"
        ).first()
        
        if user:
            print("✓ Regular user already exists")
        else:
            regular_user = User(
                username="User",
                email="user@gmail.com",
                password=hash_password("user123"),
                role_id=2  # 2 = User
            )
            db.add(regular_user)
            print("✓ Regular user created: user@gmail.com / user123")
        
        db.commit()
        print("\n✓ Default users initialized successfully")
        return True
        
    except Exception as e:
        print(f"✗ Error: {e}")
        import traceback
        traceback.print_exc()
        db.rollback()
        return False
    finally:
        db.close()

if __name__ == "__main__":
    create_default_users()
