import datetime
import uuid

from fastapi_users import schemas
from pydantic import BaseModel


class UserRead(schemas.BaseUser[uuid.UUID]):
    pass


class UserCreate(schemas.BaseUserCreate):
    pass


class UserUpdate(schemas.BaseUserUpdate):
    pass


class Message(BaseModel):
    message: str
    sent_at: datetime.datetime


class CreateMessage(Message):
    pass


class GetMessage(Message):
    id: int


class Chat(BaseModel):
    id: int


class ChatMessage(BaseModel):
    id: int
    message_id: int
    chat_id: int


class ChatMember(BaseModel):
    chat_id: int
    user_id: str


class CreateChatMember(ChatMember):
    pass


class GetChatMember(ChatMember):
    id: int


class Friend(BaseModel):
    user_1_id: str
    user_2_id: str


class CreateFriend(Friend):
    pass


class GetFriend(Friend):
    id: int
