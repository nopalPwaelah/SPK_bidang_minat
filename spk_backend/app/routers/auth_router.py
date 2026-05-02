from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.models import User
from app.schemas import LoginSchema, RegisterSchema
from app.auth import hash_password, verify_password, create_token

router = APIRouter()

# ================= DB =================
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ================= REGISTER =================
@router.post("/register", status_code=201)
def register(data: RegisterSchema, db: Session = Depends(get_db)):

    # 🔥 CEK EMAIL
    existing_user = db.query(User).filter(User.email == data.email).first()
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email sudah terdaftar"
        )

    # 🔥 SIMPAN USER
    user = User(
        username=data.username,
        email=data.email,
        password=hash_password(data.password),
        role_id=2  # default mahasiswa
    )

    db.add(user)
    db.commit()
    db.refresh(user)

    return {
        "msg": "Register berhasil",
        "email": user.email
    }

# ================= LOGIN =================
@router.post("/login")
def login(data: LoginSchema, db: Session = Depends(get_db)):

    user = db.query(User).filter(User.email == data.email).first()

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User tidak ditemukan"
        )

    if not verify_password(data.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Password salah"
        )

    # 🔥 BUAT TOKEN
    token = create_token({
        "sub": user.email,
        "role": user.role_id
    })

    return {
        "access_token": token,
        "token_type": "bearer",
        "role": user.role_id,   # 🔥 penting untuk Flutter
        "email": user.email,
        "username": user.username
    }