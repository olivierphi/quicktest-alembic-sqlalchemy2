from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase

engine = create_engine("sqlite+pysqlite:///db.sqlite3", echo=True)

# from sqlalchemy import MetaData
# metadata_obj = MetaData()

from typing import Optional

from sqlalchemy import ForeignKey, String
from sqlalchemy.orm import DeclarativeBase, Mapped, MappedAsDataclass, mapped_column, relationship
from typing_extensions import Annotated


def get_session():
    from sqlalchemy.orm import Session

    return Session(engine)


class Base(MappedAsDataclass, DeclarativeBase):
    """subclasses will be converted to dataclasses"""


intpk = Annotated[int, mapped_column(primary_key=True)]
str30 = Annotated[str, mapped_column(String(30))]
user_fk = Annotated[int, mapped_column(ForeignKey("user_account.id"))]


class User(Base):
    __tablename__ = "user_account"

    id: Mapped[intpk] = mapped_column(init=False)
    name: Mapped[str30]
    fullname: Mapped[Optional[str]] = mapped_column(default=None)
    addresses: Mapped[list["Address"]] = relationship(back_populates="user", default_factory=list)


class Address(Base):
    __tablename__ = "address"

    id: Mapped[intpk] = mapped_column(init=False)
    email_address: Mapped[str]
    user_id: Mapped[user_fk] = mapped_column(init=False)
    user: Mapped["User"] = relationship(back_populates="addresses", default=None)
