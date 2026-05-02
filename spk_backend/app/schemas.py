from pydantic import BaseModel

class LoginSchema(BaseModel):
    email: str
    password: str

class RegisterSchema(BaseModel):
    username: str
    email: str
    password: str

class KNNRequest(BaseModel):
    mahasiswa_id: int
    k: int = 3