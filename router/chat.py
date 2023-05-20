import os

from fastapi import APIRouter, Depends, HTTPException, File, UploadFile

import crud
import schemas
from database import get_async_session
from users import current_active_user

chat_router = APIRouter(prefix='/chat')


@chat_router.post("/create", response_model=schemas.Chat)
async def create_chat(second_member: str, db=Depends(get_async_session), user=Depends(current_active_user)):
    try:
        assert await crud.is_user_exist(db, second_member)
    except AssertionError:
        raise HTTPException(status_code=403, detail="Second user not found")

    # if second_member == user.id:
    #     raise HTTPException(status_code=403, detail="Trying to create self chat")

    try:
        db_chat_id = await crud.create_chat(db)
        await crud.add_chat_member(db, second_member, db_chat_id)
        await crud.add_chat_member(db, user.id, db_chat_id)
        return schemas.Chat(id=db_chat_id)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@chat_router.get("/{chat_id}/messages", response_model=list[schemas.GetChatMessage])
async def get_messages(chat_id: int, user=Depends(current_active_user), db=Depends(get_async_session)):
    # if user not in await crud.get_chat_members(db, chat_id):
    #     raise HTTPException(status_code=403, detail="Illegal access to chat")
    try:
        result = await crud.get_chat_messages(db, chat_id)
        mapped_result = [i._mapping for i in result]
        #
        # for message in result:
        #     message_data = message._mapping
        #
        #     image_path = f"attachments/{message_data['message_id']}.png"
        #     if os.path.exists(image_path):
        #         with open(image_path) as file:
        #             message_data["image"] = file
        #
        #     mapped_result.append(message_data)

        return mapped_result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@chat_router.get("/{chat_id}/members", response_model=list[schemas.GetChatMember])
async def get_chat_members(chat_id: int, db=Depends(get_async_session), user=Depends(current_active_user)):
    # if user not in await crud.get_chat_members(db, chat_id):
    #     raise HTTPException(status_code=403, detail="Illegal access to chat")
    try:
        result = await crud.get_chat_members(db, chat_id)
        mapped_result = [i._mapping for i in result]
        return mapped_result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@chat_router.post("/send")
async def send_message(message: schemas.CreateChatMessage,
                       user=Depends(current_active_user),
                       # image: UploadFile = File(default=None),
                       db=Depends(get_async_session)):
    # if user not in await crud.get_chat_members(db, chat_id):
    #     raise HTTPException(status_code=403, detail="Illegal access to chat")
    try:
        # db_message_id = await crud.add_message(db, message, user.id)
        db_chat_message = await crud.add_chat_message(db, message.chat_id, message.message, message.sent_at, user.id)

        # if image is not None:
        #     image_path = f"attachments/{db_chat_message}.png"
        #     with open(image_path, "wb") as file:
        #         file.write(await image.read())

        return {"chat_message_id": db_chat_message}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@chat_router.get("/get", response_model=list[schemas.Chat])
async def get_user_chats(user=Depends(current_active_user), db=Depends(get_async_session)):
    try:
        result = await crud.get_user_chats(db, user.id)
        mapped_result = [i._mapping for i in result]
        return mapped_result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
