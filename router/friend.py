from fastapi import APIRouter, Depends, HTTPException

import crud
import schemas
from database import get_async_session
from users import current_active_user

#friend_router является объектом маршрутизатора
friend_router = APIRouter(prefix='/friends')

#endpoint
@friend_router.post("/add")
async def add_friend(friend_id: str, user=Depends(current_active_user), db=Depends(get_async_session)):
    try:
        db_friend_id = await crud.add_friend(db, str(user.id), friend_id)
        return {"friend_id": db_friend_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

#endpoint
@friend_router.get("/get", response_model=list[schemas.GetFriend])
async def get_users_friend(user=Depends(current_active_user), db=Depends(get_async_session)):
    try:
        result = await crud.get_friends(db, user.id)
        mapped_result = [i._mapping for i in result]
        return mapped_result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

#endpoint
@friend_router.delete("/delete")
async def delete_friend(user_id: str, user=Depends(current_active_user), db=Depends(get_async_session)):
    try:
        await crud.delete_friend(db, user_id, user.id)
        return {"deleted friend", user_id}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
