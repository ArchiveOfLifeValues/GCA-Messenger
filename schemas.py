#Эти модели данных используются для валидации и передачи данных в приложении
#включая операции чтения, создания и обновления пользователей, чатов, сообщений и дружбы.
#содержит определения схем данных

import datetime # Импорт модуля datetime для работы с датами и временем
import uuid # Импорт модуля uuid для работы с уникальными идентификаторами

from fastapi_users import schemas # Импорт модулей схем fastapi-users для работы с пользователями
from pydantic import BaseModel # Импорт базовой модели данных из библиотеки Pydantic
from fastapi import UploadFile # Импорт класса UploadFile из FastAPI для работы с загружаемыми файлами


class UserRead(schemas.BaseUser[uuid.UUID]):
    pass
    # Определение модели данных UserRead, которая наследуется от базовой модели данных BaseUser из fastapi-users.
    # В качестве типа идентификатора пользователя используется uuid.UUID.
    # Пустое ключевое слово pass используется для оставления класса пустым без дополнительной функциональности.

class UserCreate(schemas.BaseUserCreate):
    pass
    # Определение модели данных UserCreate, которая наследуется от базовой модели данных BaseUserCreate из fastapi-users.
    # Пустое ключевое слово pass используется для оставления класса пустым без дополнительной функциональности.


class UserUpdate(schemas.BaseUserUpdate):
    pass
    # Определение модели данных UserUpdate, которая наследуется от базовой модели данных BaseUserUpdate из fastapi-users.
    # Пустое ключевое слово pass используется для оставления класса пустым без дополнительной функциональности.

class UserInfo(BaseModel):
    username: str
    name: str
    bio: str
    # Определение модели данных UserInfo с использованием BaseModel из библиотеки Pydantic.
    # Модель содержит три поля: username (строка), name (строка) и bio (строка).
    # Эти поля представляют информацию о пользователе, такую как имя пользователя, имя и биографию.

class GetUserInfo(UserInfo):
    pass
    # Определение модели данных GetUserInfo, которая наследуется от модели данных UserInfo.
    # Пустое ключевое слово pass используется для оставления класса пустым без дополнительной функциональности.

class CreateUserInfo(UserInfo):
    pass
    # Определение модели данных CreateUserInfo, которая наследуется от модели данных UserInfo.
    # Пустое ключевое слово pass используется для оставления класса пустым без дополнительной функциональности.

class UpdateUserInfo(UserInfo):
    pass
    # Определение модели данных UpdateUserInfo, которая наследуется от модели данных UserInfo.
    # Пустое ключевое слово pass используется для оставления класса пустым без дополнительной функциональности.

class Chat(BaseModel):
    id: int
    # Определение модели данных Chat с использованием BaseModel из библиотеки Pydantic.
    # Модель содержит одно поле id (целое число).

class ChatMember(BaseModel):
    user_id: str
    # Определение модели данных ChatMember с использованием BaseModel из библиотеки Pydantic.
    # Модель содержит одно поле user_id (строка).

class CreateChatMember(ChatMember):
    pass
    # Определение модели данных CreateChatMember, которая наследуется от модели данных ChatMember.
    # Пустое ключевое слово pass используется для оставления класса пустым без дополнительной функциональности.


class GetChatMember(ChatMember):
    pass
    # Определение модели данных GetChatMember, которая наследуется от модели данных ChatMember.
    # Пустое ключевое слово pass используется для оставления класса пустым без дополнительной функциональности.


class ChatMessage(BaseModel):
    message: str
    sent_at: datetime.datetime
    # Определение модели данных ChatMessage с использованием BaseModel из библиотеки Pydantic.
    # Модель содержит два поля: message (строка) и sent_at (объект datetime.datetime).


class CreateChatMessage(ChatMessage):
    chat_id: int
    # Определение модели данных CreateChatMessage, которая наследуется от модели данных ChatMessage.
    # Модель содержит дополнительное поле chat_id (целое число).


class GetChatMessage(ChatMessage):
    sender_id: str
    # Определение модели данных GetChatMessage, которая наследуется от модели данных ChatMessage.
    # Модель содержит дополнительное поле sender_id (строка).


class Friend(BaseModel):
    user_1_id: str
    user_2_id: str
    # Определение модели данных Friend с использованием BaseModel из библиотеки Pydantic.
    # Модель содержит два поля: user_1_id (строка) и user_2_id (строка).

class CreateFriend(Friend):
    pass
    # Определение модели данных CreateFriend, которая наследуется от модели данных Friend.
    # Пустое ключевое слово pass используется для оставления класса пустым без дополнительной функциональности.

class GetFriend(Friend):
    id: int
    # Определение модели данных GetFriend, которая наследуется от модели данных Friend.
    # Модель содержит дополнительное поле id (целое число).