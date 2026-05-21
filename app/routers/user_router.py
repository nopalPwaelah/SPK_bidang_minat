from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pydantic import BaseModel
from app.database import SessionLocal
from app.models import User

router = APIRouter()

class UserRequest(BaseModel):
    username: str
    email: str
    password: str
    role: str


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

def _role_name(role_id: int) -> str:
    if role_id == 2:
        return "admin"
    return "mahasiswa"

@router.get("/")
def get_users(db: Session = Depends(get_db)):
    users = db.query(User).all()
    return [
        {
            "id": user.id,
            "username": user.username,
            "email": user.email,
            "role": _role_name(user.role_id),
        }
        for user in users
    ]

@router.post("/")
def create_user(data: UserRequest, db: Session = Depends(get_db)):
    existing = db.query(User).filter(User.email == data.email).first()
    if existing:
        raise HTTPException(status_code=400, detail="Email sudah terdaftar")

    new_user = User(
        username=data.username,
        email=data.email,
        password=data.password,
        role_id=1 if data.role == "mahasiswa" else 2,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {
        "message": "User berhasil ditambahkan",
        "data": {
            "id": new_user.id,
            "username": new_user.username,
            "email": new_user.email,
            "role": data.role,
        }
    }

@router.delete("/{user_id}")
def delete_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User tidak ditemukan")
    db.delete(user)
    db.commit()
    return {"message": "User berhasil dihapus"}