LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := smartfox_static

LOCAL_MODULE_FILENAME := libsmartfox

LOCAL_CFLAGS += -I$(LOCAL_PATH)/../boost/include
LOCAL_LDLIBS += -L$(LOCAL_PATH)/../boost/libs/android
LOCAL_LDLIBS += -lboost_system-gcc-mt-1_55 -lboost_thread-gcc-mt-1_55 -lboost_regex-gcc-mt-1_55


LOCAL_CPPFLAGS += -fexceptions
LOCAL_CPPFLAGS += -frtti
LOCAL_CPPFLAGS += -w

LOCAL_SRC_FILES := \
        SmartFox.cpp \
Bitswarm/BaseController.cpp \
Bitswarm/BBox/BBClient.cpp \
Bitswarm/BBox/BBEvent.cpp \
Bitswarm/BitSwarmClient.cpp \
Bitswarm/BitSwarmEvent.cpp \
Bitswarm/ConnectionModes.cpp \
Bitswarm/Message.cpp \
Bitswarm/PendingPacket.cpp \
Bitswarm/UDPManager.cpp \
Controllers/ExtensionController.cpp \
Controllers/SystemController.cpp \
Core/BaseEvent.cpp \
Core/PacketHeader.cpp \
Core/SFSBuddyEvent.cpp \
Core/SFSEvent.cpp \
Core/SFSIOHandler.cpp \
Core/SFSProtocolCodec.cpp \
Core/Sockets/IPAddress.cpp \
Core/Sockets/TCPClient.cpp \
Core/Sockets/TCPSocketLayer.cpp \
Core/Sockets/UDPClient.cpp \
Core/Sockets/UDPSocketLayer.cpp \
Core/ThreadManager.cpp \
Entities/Data/SFSArray.cpp \
Entities/Data/SFSDataWrapper.cpp \
Entities/Data/SFSObject.cpp \
Entities/Data/Vec3D.cpp \
Entities/Invitation/SFSInvitation.cpp \
Entities/Managers/SFSBuddyManager.cpp \
Entities/Managers/SFSGlobalUserManager.cpp \
Entities/Managers/SFSRoomManager.cpp \
Entities/Managers/SFSUserManager.cpp \
Entities/Match/BoolMatch.cpp \
Entities/Match/LogicOperator.cpp \
Entities/Match/MatchExpression.cpp \
Entities/Match/NumberMatch.cpp \
Entities/Match/RoomProperties.cpp \
Entities/Match/StringMatch.cpp \
Entities/Match/UserProperties.cpp \
Entities/MMOItem.cpp \
Entities/MMORoom.cpp \
Entities/SFSBuddy.cpp \
Entities/SFSConstants.cpp \
Entities/SFSRoom.cpp \
Entities/SFSUser.cpp \
Entities/Variables/MMOItemVariable.cpp \
Entities/Variables/ReservedBuddyVariables.cpp \
Entities/Variables/ReservedRoomVariables.cpp \
Entities/Variables/SFSBuddyVariable.cpp \
Entities/Variables/SFSRoomVariable.cpp \
Entities/Variables/SFSUserVariable.cpp \
Exceptions/SFSCodecError.cpp \
Exceptions/SFSError.cpp \
Exceptions/SFSValidationError.cpp \
FSM/FiniteStateMachine.cpp \
FSM/FSMState.cpp \
Http/SFSWebClient.cpp \
Logging/Logger.cpp \
Logging/LoggerEvent.cpp \
Protocol/Serialization/DefaultObjectDumpFormatter.cpp \
Protocol/Serialization/DefaultSFSDataSerializer.cpp \
Requests/AdminMessageRequest.cpp \
Requests/BanUserRequest.cpp \
Requests/BaseRequest.cpp \
Requests/Buddylist/AddBuddyRequest.cpp \
Requests/Buddylist/BlockBuddyRequest.cpp \
Requests/Buddylist/BuddyMessageRequest.cpp \
Requests/Buddylist/GoOnlineRequest.cpp \
Requests/Buddylist/InitBuddyListRequest.cpp \
Requests/Buddylist/RemoveBuddyRequest.cpp \
Requests/Buddylist/SetBuddyVariablesRequest.cpp \
Requests/ChangeRoomCapacityRequest.cpp \
Requests/ChangeRoomNameRequest.cpp \
Requests/ChangeRoomPasswordStateRequest.cpp \
Requests/CreateRoomRequest.cpp \
Requests/ExtensionRequest.cpp \
Requests/FindRoomsRequest.cpp \
Requests/FindUsersRequest.cpp \
Requests/Game/CreateSFSGameRequest.cpp \
Requests/Game/InvitationReplyRequest.cpp \
Requests/Game/InviteUsersRequest.cpp \
Requests/Game/QuickJoinGameRequest.cpp \
Requests/Game/SFSGameSettings.cpp \
Requests/GenericMessageRequest.cpp \
Requests/HandshakeRequest.cpp \
Requests/JoinRoomRequest.cpp \
Requests/KickUserRequest.cpp \
Requests/LeaveRoomRequest.cpp \
Requests/LoginRequest.cpp \
Requests/LogoutRequest.cpp \
Requests/ManualDisconnectionRequest.cpp \
Requests/MessageRecipientMode.cpp \
Requests/MMO/MapLimits.cpp \
Requests/MMO/MMORoomSettings.cpp \
Requests/MMO/SetMMOItemVariables.cpp \
Requests/MMO/SetUserPositionRequest.cpp \
Requests/ModeratorMessageRequest.cpp \
Requests/ObjectMessageRequest.cpp \
Requests/PingPongRequest.cpp \
Requests/PlayerToSpectatorRequest.cpp \
Requests/PrivateMessageRequest.cpp \
Requests/PublicMessageRequest.cpp \
Requests/RoomEvents.cpp \
Requests/RoomExtension.cpp \
Requests/RoomPermissions.cpp \
Requests/RoomSettings.cpp \
Requests/SetRoomVariablesRequest.cpp \
Requests/SetUserVariablesRequest.cpp \
Requests/SpectatorToPlayerRequest.cpp \
Requests/SubscribeRoomGroupRequest.cpp \
Requests/UnsubscribeRoomGroupRequest.cpp \
Util/ByteArray.cpp \
Util/ClientDisconnectionReason.cpp \
Util/ConfigData.cpp \
Util/ConfigLoader.cpp \
Util/EventDispatcher.cpp \
Util/LagMonitor.cpp \
Util/md5/md5.c \
Util/PasswordUtil.cpp \
Util/SFSErrorCodes.cpp \
Util/XMLParser/XMLNode.cpp \
Util/XMLParser/XMLNodeList.cpp \
Util/XMLParser/XMLNodeValue.cpp \
Util/XMLParser/XMLObject.cpp \
Util/XMLParser/XMLParser.cpp

LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/..

LOCAL_C_INCLUDES := $(LOCAL_PATH)/..
                                 
include $(BUILD_STATIC_LIBRARY)
