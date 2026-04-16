from fastapi import FastAPI
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base
import os

app = FastAPI()

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://user:pass@db:5432/tododb")

engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

@app.get("/")
def root():
    return {"message": "todo api is working"}

# отримати всі задачі
@app.get("/tasks")
def get_tasks():
    with SessionLocal() as session:
        tasks = session.execute(text("SELECT * FROM tasks")).mappings().all()
    return {"tasks": [dict(row) for row in tasks]}

# додати задачу
@app.post("/tasks")
def add_task(title: str):
    with SessionLocal() as session:
        session.execute(
            text("INSERT INTO tasks (title, is_done) VALUES (:title, false)"),
            {"title": title}
        )
        session.commit()
    return {"message": "Task added"}

# позначити як виконану
@app.put("/tasks/{task_id}")
def mark_done(task_id: int):
    with SessionLocal() as session:
        session.execute(
            text("UPDATE tasks SET is_done = true WHERE id = :id"),
            {"id": task_id}
        )
        session.commit()
    return {"message": "Task marked as done"}