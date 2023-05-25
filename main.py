from fastapi import Depends, FastAPI

from database import create_db_and_tables
from schemas import UserCreate, UserRead, UserUpdate
from users import auth_backend, current_active_user, fastapi_users
from models import User
from router import chat_router, friend_router, user_router

# Создание экземпляра FastAPI, который представляет собой основу веб-приложения.
app = FastAPI()
# Подключение маршрутов для аутентификации (authentication)
app.include_router(
    fastapi_users.get_auth_router(auth_backend), prefix="/auth/jwt", tags=["auth"]
)
# Подключение маршрутов для регистрации пользователей
app.include_router(
    fastapi_users.get_register_router(UserRead, UserCreate),
    prefix="/auth",
    tags=["auth"],
)
# Подключение маршрутов для сброса пароля
app.include_router(
    fastapi_users.get_reset_password_router(),
    prefix="/auth",
    tags=["auth"],
)
# Подключение маршрутов для подтверждения (верификации) пользователей
app.include_router(
    fastapi_users.get_verify_router(UserRead),
    prefix="/auth",
    tags=["auth"],
)
# Подключение маршрутов для операций с пользователями (получение, обновление)
app.include_router(
    fastapi_users.get_users_router(UserRead, UserUpdate),
    prefix="/users",
    tags=["users"],
)
# Подключение маршрутов, определенных в chat_router, с тегом 'chat'
app.include_router(chat_router, tags=['chat'])
# Подключение маршрутов, определенных в friend_router, с тегом 'friend'
app.include_router(friend_router, tags=['friend'])
# Подключение маршрутов, определенных в user_router, с тегом 'user'
app.include_router(user_router, tags=['user'])


@app.get("/authenticated-route")  # Определение маршрута для аутентифицированного доступа
async def authenticated_route(user: User = Depends(current_active_user)):
    return {"message": f"Hello {user.email}!"}


@app.on_event("startup") # Обработчик события запуска приложения
async def on_startup():
    await create_db_and_tables()
