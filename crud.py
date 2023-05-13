# Create Read Update Delete
import datetime

from sqlalchemy.orm import Session
from sqlalchemy import insert, select, delete, and_, or_
from fastapi import Depends

import models, schemas


async def create_chat(db: Session):
    stmt = insert(models.Chat.__table__)
    result = await db.execute(stmt)
    await db.commit()
    chat_id = result.inserted_primary_key[0]
    return chat_id


async def add_chat_member(db: Session, user_id: str, chat_id: int):
    stmt = insert(models.ChatMember.__table__).values(user_id=str(user_id), chat_id=chat_id)
    result = await db.execute(stmt)
    await db.commit()
    row_id = result.inserted_primary_key[0]
    return row_id


async def get_chat_members(db: Session, chat_id: int):
    chat_member_table = models.ChatMember.__table__
    stmt = select(chat_member_table).where(chat_member_table.c.chat_id == chat_id)
    result = await db.execute(stmt)
    rows = result.all()
    return rows


async def get_user_chats(db: Session, user_id: str):
    chats_table = models.ChatMember.__table__
    stmt = select(chats_table).where(chats_table.c.user_id == str(user_id))
    user_chats = await db.execute(stmt)
    return user_chats.all()


async def add_chat_message(db: Session, user_id: str, message_id: int, chat_id: int):
    stmt = insert(models.ChatMessage.__table__).values(user_id=str(user_id), message_id=message_id, chat_id=chat_id)
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
    chat_message_table = models.ChatMessage.__table__
    message_table = models.Message.__table__

    chat_messages = await db.execute(select(chat_message_table).where(chat_message_table.c.chat_id == chat_id))
    chat_messages = chat_messages.all()
    messages = []

    for i in chat_messages:
        result = await db.execute(select(message_table).where(message_table.c.id == i.message_id))
        result = result.first()
        messages.append(result)

    return messages


async def add_message(db: Session, msg: schemas.CreateMessage, user_id: str) -> int:
    stmt = insert(models.Message.__table__).values(message=msg.message, sent_at=msg.sent_at, sender_id=str(user_id))
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
