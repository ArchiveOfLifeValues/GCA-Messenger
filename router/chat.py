from fastapi import APIRouter, Depends, HTTPException

import crud
import schemas
from database import get_async_session
from users import current_active_user

chat_router = APIRouter(prefix='/chat')


@chat_router.get("/{id}/messages", response_model=list[schemas.GetMessage])
async def get_messages(chat_id: int, db=Depends(get_async_session), user=Depends(current_active_user)):
    # if user not in crud.get_chat_members(db, chat_id):
    #     raise HTTPException(status_code=500, detail="illegal access to chat")
    result = await crud.get_chat_messages(db, chat_id)
    mapped_result = []
    for i in result:
        mapped_result.append(i._mapping)
    return mapped_result


@chat_router.get("/{id}/members", response_model=list[schemas.GetChatMember])
async def get_chat_members(chat_id: int, db=Depends(get_async_session), user=Depends(current_active_user)):
    # if user not in crud.get_chat_members(db, chat_id):
    #     raise HTTPException(status_code=500, detail="illegal access to chat")
    result = await crud.get_chat_members(db, chat_id)
    mapped_result = []
    for i in result:
        mapped_result.append(i._mapping)
    return mapped_result


@chat_router.post("/create", response_model=schemas.Chat)
async def create_chat(second_member: str, db=Depends(get_async_session), user=Depends(current_active_user)):
    try:
        assert await crud.is_user_exist(db, second_member) is True
    except AssertionError:
        raise HTTPException(status_code=403, detail="second user not found")

    if second_member == user.id:
        raise HTTPException(status_code=403, detail="trying to create shiza chat")

    db_chat_id = await crud.create_chat(db)
    await crud.add_chat_member(db, second_member, db_chat_id)
    await crud.add_chat_member(db, user.id, db_chat_id)
    return schemas.Chat(id=db_chat_id)


@chat_router.post("/{id}/send")
async def send_message(chat_id: int, message: schemas.CreateMessage, db=Depends(get_async_session),
                       user=Depends(current_active_user)):
    # if user not in crud.get_chat_members(db, chat_id):
    #     raise HTTPException(status_code=500, detail="illegal access to chat")

    db_message_id = await crud.add_message(db, message, user.id)
    db_chat_message = await crud.add_chat_message(db, user.id, db_message_id, chat_id)
    return {"message_id": db_message_id, "chat_message_id": db_chat_message}


@chat_router.get("/get", response_model=list[schemas.Chat])
async def get_user_chats(user=Depends(current_active_user), db=Depends(get_async_session)):
    result = await crud.get_user_chats(db, user.id)
    mapped_result = []
    for i in result:
        mapped_result.append(i._mapping)
    return mapped_result
