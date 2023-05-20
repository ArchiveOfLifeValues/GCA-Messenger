import datetime
import uuid

from fastapi_users import schemas
from pydantic import BaseModel
from fastapi import UploadFile


class UserRead(schemas.BaseUser[uuid.UUID]):
    pass


class UserCreate(schemas.BaseUserCreate):
    pass


class UserUpdate(schemas.BaseUserUpdate):
    pass


class UserInfo(BaseModel):
    username: str
    name: str
    bio: str


class GetUserInfo(UserInfo):
    id: int
    user_id: str
    pass


class CreateUserInfo(UserInfo):
    pass


class UpdateUserInfo(UserInfo):
    pass


class Chat(BaseModel):
    id: int


class ChatMember(BaseModel):
    chat_id: int
    user_id: str


class CreateChatMember(ChatMember):
    pass


class GetChatMember(ChatMember):
    id: int


class ChatMessage(BaseModel):
    chat_id: int
    message: str
    sent_at: datetime.datetime


class CreateChatMessage(ChatMessage):
    pass


class GetChatMessage(ChatMessage):
    id: int
    sender_id: str


class Friend(BaseModel):
    user_1_id: str
    user_2_id: str


class CreateFriend(Friend):
    pass


class GetFriend(Friend):
    id: int
