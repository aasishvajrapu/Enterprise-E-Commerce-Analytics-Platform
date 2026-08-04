from sqlalchemy import text
from database import get_engine

try:
    engine = get_engine()

    with engine.connect() as conn:
        db_name = conn.execute(text("SELECT current_database();")).scalar()
        version = conn.execute(text("SELECT version();")).scalar()

        print(f"Connected to database : {db_name}")
        print(f"PostgreSQL Version    : {version}")

    print("\n✅ Database connection successful!")

except Exception as e:
    print("\n❌ Database connection failed!")
    print(e)