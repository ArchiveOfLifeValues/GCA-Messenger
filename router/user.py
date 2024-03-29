from fastapi import APIRouter, Depends, HTTPException, File, UploadFile
from fastapi.responses import StreamingResponse, FileResponse

import crud
import schemas
from database import get_async_session
from users import current_active_user

#user_router является объектом маршрутизатора
user_router = APIRouter(prefix='/user')

#endpoint
@user_router.get("/all", response_model=list[schemas.UserRead])
async def get_all_users(db=Depends(get_async_session)):
    try:
        db_all_users = await crud.get_all_users(db) # Вызов функции get_all_users из модуля crud для получения всех пользователей из базы данных
        return db_all_users # Возвращение списка пользователей в качестве ответа
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e)) # Если произошла ошибка, генерирование исключения HTTPException с кодом состояния 500 и сообщением об ошибке

#endpoint
@user_router.get("/photo/get")
async def get_user_photo(user_id: str, db = Depends(get_async_session)):
    if not await crud.is_user_exist(db, user_id):
        raise HTTPException(status_code=403, detail="User not found")

    file_path = f"photo/user_{user_id}.png"
    try:
        with open(file_path, "rb") as file:
            photo_data = file.read()
            return StreamingResponse(iter([photo_data]), media_type="image/png")
    except FileNotFoundError:
        raise HTTPException(status_code=404, detail="User photo not found")
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

#endpoint
@user_router.post("/photo/set")
async def set_user_photo(user=Depends(current_active_user), photo: UploadFile = File(...)):
    if not await crud.is_user_exist(db, user.id):
        raise HTTPException(status_code=403, detail="User not found")

    file_path = f"photo/user_{user.id}.png"
    try:
        with open(file_path, "wb") as file:
            file.write(await photo.read())
            return {"message": "User photo has been set successfully"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

#endpoint
@user_router.get("/info/get", response_model=schemas.GetUserInfo)
async def get_user_info(user_id: str, db=Depends(get_async_session)):
    if not await crud.is_user_exist(db, user_id):
        raise HTTPException(status_code=403, detail="User not found")

    try:
        db_user_info = await crud.get_user_info(db, user_id)

        if db_user_info is None:
            raise HTTPException(status_code=404, detail="User info not found")

        return schemas.GetUserInfo(username=db_user_info.username,
                                   name=db_user_info.name,
                                   bio=db_user_info.bio)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

#endpoint
@user_router.post("/info/set")
async def set_user_info(user_info: schemas.CreateUserInfo, user=Depends(current_active_user),
                        db=Depends(get_async_session)):
    if not await crud.is_user_exist(db, user.id):
        raise HTTPException(status_code=403, detail="User not found")

    if await crud.is_user_info_exist(db, user.id):
        raise HTTPException(status_code=403, detail="User info already exist")

    try:
        await crud.create_user_info(db, user.id, user_info)
        return "User info successfully setted"
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

#endpoint
@user_router.patch("/info/update")
async def update_user_info(user_info: schemas.UpdateUserInfo,
                           user=Depends(current_active_user),
                           db=Depends(get_async_session),):
    if not await crud.is_user_exist(db, user.id):
        raise HTTPException(status_code=403, detail="User not found")

    try:
        await crud.update_user_info(db, user.id, user_info)
        return "User info successfully updated"
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
