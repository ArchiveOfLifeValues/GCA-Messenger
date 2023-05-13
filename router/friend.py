from fastapi import APIRouter, Depends, HTTPException

import crud
import schemas
from database import get_async_session
from users import current_active_user

friend_router = APIRouter(prefix='/user')


@friend_router.post("/{id}/add_friend")
async def add_friend(friend_id: str, user=Depends(current_active_user), db=Depends(get_async_session)):
    db_friend_id = await crud.add_friend(db, str(user.id), friend_id)
    return {"friend_id": db_friend_id}


@friend_router.get("/{id}/friends", response_model=list[schemas.GetFriend])
async def get_users_friend(user=Depends(current_active_user), db=Depends(get_async_session)):
    result = await crud.get_friends(db, user.id)
    mapped_result = []
    for i in result:
        mapped_result.append(i._mapping)
    return mapped_result

# @friend_router.get("/{id}.friend", response_modes=schemas.GetFriend)


@friend_router.post("/{id}/delete_friend")
async def delete_friend(user_id: str, user=Depends(current_active_user), db=Depends(get_async_session)):
    await crud.delete_friend(db, user_id, user.id)
    return {"deleted friend", user_id}
