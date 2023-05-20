from fastapi import Depends
from fastapi_users_db_sqlalchemy import SQLAlchemyUserDatabase
from sqlalchemy import Boolean, Column, ForeignKey, Integer, String, DateTime, CHAR
from fastapi_users.db import SQLAlchemyBaseUserTableUUID
from sqlalchemy.ext.asyncio import AsyncSession

from database import Base, get_async_session


class User(SQLAlchemyBaseUserTableUUID, Base):
    pass


async def get_user_db(session: AsyncSession = Depends(get_async_session)):
    yield SQLAlchemyUserDatabase(session, User)


class UserInfo(Base):
    __tablename__ = "user_info"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(CHAR(32), ForeignKey("user.id"))
    name = Column(CHAR(32))
    username = Column(CHAR(32))
    bio = Column(CHAR(32))


class Chat(Base):
    __tablename__ = "chat"

    id = Column(Integer, primary_key=True, index=True)


class ChatMember(Base):
    __tablename__ = "chat_member"

    id = Column(Integer, primary_key=True, index=True)
    chat_id = Column(Integer, ForeignKey("chat.id"))
    user_id = Column(CHAR(32), ForeignKey("user.id"))


class ChatMessage(Base):
    __tablename__ = "chat_message"

    id = Column(Integer, primary_key=True, index=True)
    chat_id = Column(Integer, ForeignKey("chat.id"))
    message = Column(String)
    sent_at = Column(DateTime)
    sender_id = Column(CHAR(32))


class Friend(Base):
    __tablename__ = "friend"

    id = Column(Integer, primary_key=True, index=True)
    user_1_id = Column(CHAR(32), ForeignKey("user.id"))
    user_2_id = Column(CHAR(32), ForeignKey("user.id"))
