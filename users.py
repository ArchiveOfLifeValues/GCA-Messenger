#данный код настраивает аутентификацию на основе JWT-токенов
#создает менеджер пользователей и позволяет работать с пользователями через FastAPIUsers.


import uuid # Импорт модуля uuid для работы с уникальными идентификаторами
from typing import Optional # Импорт типа Optional из модуля typing

from fastapi import Depends, Request # Импорт классов Depends и Request из модуля fastapi
from fastapi_users import BaseUserManager, FastAPIUsers, UUIDIDMixin  # Импорт классов и миксинов из модуля fastapi_users
from fastapi_users.authentication import (
    AuthenticationBackend, # Импорт класса AuthenticationBackend из модуля fastapi_users.authentication
    BearerTransport, # Импорт класса BearerTransport из модуля fastapi_users.authentication
    JWTStrategy, # Импорт класса JWTStrategy из модуля fastapi_users.authentication
)
from fastapi_users.db import SQLAlchemyUserDatabase # Импорт класса SQLAlchemyUserDatabase из модуля fastapi_users.db

from models import User, get_user_db # Импорт класса User и функции get_user_db из модуля models
from settings import SECRET # Импорт переменной SECRET из модуля settings


class UserManager(UUIDIDMixin, BaseUserManager[User, uuid.UUID]):
    reset_password_token_secret = SECRET
    verification_token_secret = SECRET

    async def on_after_register(self, user: User, request: Optional[Request] = None):
        # Вывод сообщения о регистрации пользователя с указанием его идентификатора
        print(f"User {user.id} has registered.")

    async def on_after_forgot_password(
            self, user: User, token: str, request: Optional[Request] = None
    ):
        # Вывод сообщения о том, что пользователь забыл свой пароль и указание токена сброса пароля
        print(f"User {user.id} has forgot their password. Reset token: {token}")

    async def on_after_request_verify(
            self, user: User, token: str, request: Optional[Request] = None
    ):
        # Вывод сообщения о запросе подтверждения учетной записи с указанием токена подтверждения
        print(f"Verification requested for user {user.id}. Verification token: {token}")


# Определение асинхронного генератора get_user_manager
async def get_user_manager(user_db: SQLAlchemyUserDatabase = Depends(get_user_db)):
    yield UserManager(user_db)


# Создание объекта BearerTransport для аутентификации посредством передачи токена
bearer_transport = BearerTransport(tokenUrl="auth/jwt/login")


def get_jwt_strategy() -> JWTStrategy:
    # Функция, возвращающая экземпляр класса JWTStrategy
    # JWTStrategy - класс, предоставляющий стратегию аутентификации на основе JWT (JSON Web Token)
    return JWTStrategy(secret=SECRET, lifetime_seconds=None)
# Возвращает экземпляр JWTStrategy с заданными параметрами:
    # - secret: Секретный ключ (секрет), используемый для подписи и проверки JWT-токена
    #           В данном случае значение берется из переменной SECRET
    # - lifetime_seconds: Время жизни (срок действия) JWT-токена в секундах
    #                     В данном случае установлено значение 3600 секунд, что соответствует 1 часу


auth_backend = AuthenticationBackend(
    name="jwt", # Указываем имя аутентификационного бэкэнда (в данном случае JWT)
    transport=bearer_transport, # Указываем транспорт для передачи JWT-токена (в данном случае BearerTransport)
    get_strategy=get_jwt_strategy, # Функция для получения стратегии аутентификации (в данном случае JWTStrategy)
)

# Создание экземпляра класса FastAPIUsers для работы с пользователями
# Аргументы конструктора:
#   - get_user_manager: функция, возвращающая менеджер пользователей (UserManager)
#   - [auth_backend]: список аутентификационных бэкэндов (в данном случае только один элемент)
fastapi_users = FastAPIUsers[User, uuid.UUID](get_user_manager, [auth_backend])

# Получение текущего активного пользователя
# current_user - функция FastAPIUsers, которая возвращает зависимость для получения текущего пользователя
# Аргументы функции:
#   - active=True: флаг, указывающий на необходимость получения только активных пользователей
current_active_user = fastapi_users.current_user(active=True)
