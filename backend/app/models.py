from sqlalchemy import Table, Column, Integer, String
from . import metadata

items = Table(
    "items",
    metadata,
    Column("id", Integer, primary_key=True),
    Column("title", String, nullable=False),
    Column("thumbnail", String, nullable=False),
    Column("description", String, nullable=False),
)
