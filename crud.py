# Create Read Update Delete
import datetime

from sqlalchemy.orm import Session
from sqlalchemy import insert, select, delete, update, and_, or_
from fastapi import Depends

import models
import schemas


async def create_user_info(db: Session, user_id: str, user_info: schemas.CreateUserInfo):
    table = models.UserInfo.__table__
    stmt = insert(table).values(user_id=str(user_id), name=user_info.name, username=user_info.username,
                                bio=user_info.bio)
    await db.execute(stmt)
    await db.commit()


async def get_user_info(db: Session, user_id: str):
    table = models.UserInfo.__table__
    stmt = select(table).where(table.c.user_id == user_id)
    result = await db.execute(stmt)
    row = result.first() if result else None
    return row


async def update_user_info(db: Session, user_id: str, user_info: schemas.UpdateUserInfo):
    table = models.UserInfo.__table__
    stmt = update(table).where(table.c.user_id == user_id).values(name=user_info.name, username=user_info.username,
                                                                  bio=user_info.bio)
    await db.execute(stmt)
    await db.commit()


async def create_chat(db: Session):
    table = models.Chat.__table__
    stmt = insert(table)
    result = await db.execute(stmt)
    await db.commit()
    chat_id = result.inserted_primary_key[0]
    return chat_id


async def add_chat_member(db: Session, user_id: str, chat_id: int):
    table = models.ChatMember.__table__
    stmt = insert(table).values(user_id=str(user_id), chat_id=chat_id)
    result = await db.execute(stmt)
    await db.commit()
    row_id = result.inserted_primary_key[0]
    return row_id


async def get_chat_members(db: Session, chat_id: int):
    table = models.ChatMember.__table__
    stmt = select(table).where(table.c.chat_id == chat_id)
    result = await db.execute(stmt)
    rows = result.all()
    return rows


async def get_user_chats(db: Session, user_id: str):
    table = models.ChatMember.__table__
    stmt = select(table).where(table.c.user_id == str(user_id))
    user_chats = await db.execute(stmt)
    return user_chats.all()


async def add_chat_message(db: Session, chat_id: int, message: str, sent_at: datetime.datetime, user_id: str):
    table = models.ChatMessage.__table__
    stmt = insert(table).values(chat_id=chat_id, message=message, sent_at=sent_at, sender_id=str(user_id))
    result = await db.execute(stmt)
    await db.commit()
    return result.inserted_primary_key[0]


async def is_user_exist(db: Session, user_id: str):
    table = models.User.__table__
    stmt = select(table).where(table.c.id == user_id)
    result = await db.execute(stmt)
    result = result.all()
    if len(result) == 0:
        return False
    return True


async def get_chat_messages(db: Session, chat_id: int):
    table = models.ChatMessage.__table__
    stmt = select(table).where(table.c.chat_id == chat_id)
    messages = await db.execute(stmt)
    return messages.all()


async def add_message(db: Session, msg: schemas.CreateChatMessage, user_id: str) -> int:
    table = models.Message.__table__
    stmt = insert(table).values(message=msg.message, sent_at=msg.sent_at, sender_id=str(user_id))
    result = await db.execute(stmt)
    await db.commit()
    return result.inserted_primary_key[0]


async def add_friend(db: Session, user_1_id: str, user_2_id: str):
    stmt = insert(models.Friend.__table__).values(user_1_id=user_1_id, user_2_id=user_2_id)
    result = await db.execute(stmt)
    await db.commit()
    return result.inserted_primary_key[0]


async def get_friends(db: Session, user_id: str):
    friends_table = models.Friend.__table__
    stmt = select(friends_table).where(
        or_(
            friends_table.c.user_1_id == str(user_id),
            friends_table.c.user_2_id == str(user_id)
        )
    )
    friends = await db.execute(stmt)
    return friends.all()


async def delete_friend(db: Session, user_1_id: str, user_2_id: str):
    stmt = delete(models.Friend.__table__).where(
        and_(
            models.Friend.user_1_id == str(user_1_id),
            models.Friend.user_2_id == str(user_2_id)
        )
    )
    await db.execute(stmt)
    await db.commit()


async def get_all_users(db: Session):
    stmt = select(models.User.__table__)
    users = await db.execute(stmt)
    return users.all()
