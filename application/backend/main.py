from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session
from dotenv import load_dotenv
import os

# Load environment variables from .env
load_dotenv()

# Initialize FastAPI app
app = FastAPI()

# CORS config
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://frontend.olorunfemilawal.com"],  # Update as needed
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database URL from environment
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:password@localhost:5432/tvshows")

# SQLAlchemy setup
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False)
Base = declarative_base()

# Define a simple model
class TvShow(Base):
    __tablename__ = "tv_shows"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)

# Create the database tables
Base.metadata.create_all(bind=engine)

# Dependency to get DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Routes
@app.get("/")
def root():
    return {"message": "Welcome to the TV Shows API with PostgreSQL!"}

@app.get("/api/shows")
def get_tv_shows(db: Session = Depends(get_db)):
    shows = db.query(TvShow).all()
    return [{"id": show.id, "title": show.title} for show in shows]
