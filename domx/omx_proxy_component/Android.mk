LOCAL_PATH:= $(call my-dir)

ifeq ($(shell test $(PLATFORM_SDK_VERSION) -ge 16 || echo 1),)
	FRAMEWORKS_MEDIA_BASE := frameworks/native/include/media/hardware
else
	FRAMEWORKS_MEDIA_BASE := frameworks/base/include/media/stagefright
endif


TI_OMXPROXY_COMMON_INCLUDES := \
	$(LOCAL_PATH)/../omx_core/inc \
	$(LOCAL_PATH)/../mm_osal/inc \
	$(LOCAL_PATH)/../domx \
	$(LOCAL_PATH)/../domx/omx_rpc/inc \
	$(LOCAL_PATH)/../domx/plugins/inc/ \
	frameworks/native/include/media/openmax

TI_OMXPROXY_DECODER_INCLUDES := \
	$(HARDWARE_TI_OMAP4_BASE)/../../libhardware/include \
	$(HARDWARE_TI_OMAP4_BASE)/hwc/

TI_OMXPROXY_ENCODER_INCLUDES := \
	$(LOCAL_PATH)/omx_video_enc/inc \
	$(HARDWARE_TI_OMAP4_BASE)/camera/inc \
	$(HARDWARE_TI_OMAP4_BASE)/hwc \
	$(FRAMEWORKS_MEDIA_BASE) \
	system/core/include/cutils


TI_OMXPROXY_COMMON_CFLAGS := \
	$(ANDROID_API_CFLAGS) \
	-D_Android \
	-DUSE_ION \
	-DANDROID_QUIRK_CHANGE_PORT_VALUES \
	-DANDROID_QUIRK_LOCK_BUFFER \
	-DENABLE_GRALLOC_BUFFERS

ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),tuna)
	TI_OMXPROXY_COMMON_CFLAGS += -DDOMX_TUNA
endif

TI_OMXPROXY_DECODER_CFLAGS := \
	-DUSE_ENHANCED_PORTRECONFIG \
	-DSET_STRIDE_PADDING_FROM_PROXY

TI_OMXPROXY_ENCODER_CFLAGS := \
	-DANDROID_CUSTOM_OPAQUECOLORFORMAT


TI_OMXPROXY_COMMON_SHARED_LIBRARIES := \
	libmm_osal \
	libOMX_Core \
	liblog \
	libdomx

TI_OMXPROXY_DECODER_SHARED_LIBRARIES := \
	libhardware

TI_OMXPROXY_ENCODER_SHARED_LIBRARIES := \
	libhardware \
	libcutils


#
# libOMX.TI.DUCATI1.MISC.SAMPLE
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
	$(TI_OMXPROXY_COMMON_INCLUDES)

LOCAL_SHARED_LIBRARIES := \
	$(TI_OMXPROXY_COMMON_SHARED_LIBRARIES)

LOCAL_CFLAGS := $(TI_OMXPROXY_COMMON_CFLAGS)

LOCAL_SRC_FILES := omx_sample/src/omx_proxy_sample.c

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libOMX.TI.DUCATI1.MISC.SAMPLE
include $(BUILD_HEAPTRACKED_SHARED_LIBRARY)


#
# libOMX.TI.DUCATI1.VIDEO.DECODER
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
	$(TI_OMXPROXY_COMMON_INCLUDES) \
	$(TI_OMXPROXY_DECODER_INCLUDES)

LOCAL_SHARED_LIBRARIES := \
	$(TI_OMXPROXY_COMMON_SHARED_LIBRARIES) \
	$(TI_OMXPROXY_DECODER_SHARED_LIBRARIES)

LOCAL_CFLAGS := \
	$(TI_OMXPROXY_COMMON_CFLAGS) \
	$(TI_OMXPROXY_DECODER_CFLAGS)

LOCAL_SRC_FILES := \
	omx_video_dec/src/omx_proxy_videodec.c \
	omx_video_dec/src/omx_proxy_videodec_utils.c

# Uncomment the below 2 lines to enable the run time
# dump of NV12 buffers from Decoder/Camera
# based on setprop control
#LOCAL_CFLAGS += -DENABLE_RAW_BUFFERS_DUMP_UTILITY
#LOCAL_SHARED_LIBRARIES += libcutils

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libOMX.TI.DUCATI1.VIDEO.DECODER
include $(BUILD_HEAPTRACKED_SHARED_LIBRARY)


#
# libOMX.TI.DUCATI1.VIDEO.DECODER.secure
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
	$(TI_OMXPROXY_COMMON_INCLUDES) \
	$(TI_OMXPROXY_DECODER_INCLUDES)

LOCAL_SHARED_LIBRARIES := \
	$(TI_OMXPROXY_COMMON_SHARED_LIBRARIES) \
	$(TI_OMXPROXY_DECODER_SHARED_LIBRARIES) \
	libOMX.TI.DUCATI1.VIDEO.DECODER

LOCAL_CFLAGS := \
	$(TI_OMXPROXY_COMMON_CFLAGS) \
	$(TI_OMXPROXY_DECODER_CFLAGS)

LOCAL_SRC_FILES := omx_video_dec/src/omx_proxy_videodec_secure.c

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libOMX.TI.DUCATI1.VIDEO.DECODER.secure
include $(BUILD_HEAPTRACKED_SHARED_LIBRARY)


#
# libOMX.TI.DUCATI1.VIDEO.CAMERA
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
	$(TI_OMXPROXY_COMMON_INCLUDES) \
	$(HARDWARE_TI_OMAP4_BASE)/include/ \
	$(LOCAL_PATH)/omx_camera/inc/

LOCAL_SHARED_LIBRARIES := \
	$(TI_OMXPROXY_COMMON_SHARED_LIBRARIES)

LOCAL_CFLAGS := $(TI_OMXPROXY_COMMON_CFLAGS)

ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),tuna)
LOCAL_CFLAGS += -DDOMX_TUNA
endif

LOCAL_SRC_FILES := \
	omx_camera/src/omx_proxy_camera.c \
	omx_camera/src/proxy_camera_android_glue.c

ifeq ($(BOARD_USE_TI_LIBION),true)
	LOCAL_SHARED_LIBRARIES += libion_ti
	LOCAL_CFLAGS += -DUSE_TI_LIBION
else
	LOCAL_SHARED_LIBRARIES += libion
	LOCAL_SRC_FILES += ../../libion/ion_ti_custom.c
	LOCAL_C_INCLUDES += $(HARDWARE_TI_OMAP4_BASE)/libion
endif

ifdef OMAP_ENHANCEMENT_VTC
	LOCAL_CFLAGS += -DOMAP_ENHANCEMENT_VTC
endif

LOCAL_CFLAGS += -DTMS32060 -D_DB_TIOMAP -DSYSLINK_USE_SYSMGR -DSYSLINK_USE_LOADER
LOCAL_CFLAGS += -D_Android -DSET_STRIDE_PADDING_FROM_PROXY -DANDROID_QUIRK_CHANGE_PORT_VALUES -DUSE_ENHANCED_PORTRECONFIG
LOCAL_CFLAGS += -DANDROID_QUIRK_LOCK_BUFFER -DUSE_ION
LOCAL_CFLAGS += $(ANDROID_API_CFLAGS)
LOCAL_MODULE_TAGS:= optional

ifdef TI_CAMERAHAL_USES_LEGACY_DOMX_DCC
	LOCAL_CFLAGS += -DUSES_LEGACY_DOMX_DCC
endif

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libOMX.TI.DUCATI1.VIDEO.CAMERA
include $(BUILD_HEAPTRACKED_SHARED_LIBRARY)


#
# libOMX.TI.DUCATI1.VIDEO.H264E
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
	$(TI_OMXPROXY_COMMON_INCLUDES) \
	$(TI_OMXPROXY_ENCODER_INCLUDES)

LOCAL_SHARED_LIBRARIES := \
	$(TI_OMXPROXY_COMMON_SHARED_LIBRARIES) \
	$(TI_OMXPROXY_ENCODER_SHARED_LIBRARIES)

LOCAL_CFLAGS := \
	$(TI_OMXPROXY_COMMON_CFLAGS) \
	$(TI_OMXPROXY_ENCODER_CFLAGS)

LOCAL_SRC_FILES := omx_video_enc/src/omx_h264_enc/src/omx_proxy_h264enc.c

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libOMX.TI.DUCATI1.VIDEO.H264E
include $(BUILD_HEAPTRACKED_SHARED_LIBRARY)


#
# libOMX.TI.DUCATI1.VIDEO.VC1E
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
	$(TI_OMXPROXY_COMMON_INCLUDES) \
	$(TI_OMXPROXY_ENCODER_INCLUDES)

LOCAL_SHARED_LIBRARIES := \
	$(TI_OMXPROXY_COMMON_SHARED_LIBRARIES) \
	$(TI_OMXPROXY_ENCODER_SHARED_LIBRARIES)

LOCAL_CFLAGS := \
	$(TI_OMXPROXY_COMMON_CFLAGS) \
	$(TI_OMXPROXY_ENCODER_CFLAGS)

LOCAL_SRC_FILES := omx_video_enc/src/omx_vc1_enc/src/omx_proxy_vc1enc.c

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libOMX.TI.DUCATI1.VIDEO.VC1E
include $(BUILD_HEAPTRACKED_SHARED_LIBRARY)


#
# libOMX.TI.DUCATI1.VIDEO.H264SVCE
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
	$(TI_OMXPROXY_COMMON_INCLUDES) \
	$(TI_OMXPROXY_ENCODER_INCLUDES)

LOCAL_SHARED_LIBRARIES := \
	$(TI_OMXPROXY_COMMON_SHARED_LIBRARIES) \
	$(TI_OMXPROXY_ENCODER_SHARED_LIBRARIES)

LOCAL_CFLAGS := \
	$(TI_OMXPROXY_COMMON_CFLAGS) \
	$(TI_OMXPROXY_ENCODER_CFLAGS)

LOCAL_SRC_FILES := omx_video_enc/src/omx_h264svc_enc/src/omx_proxy_h264svcenc.c

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libOMX.TI.DUCATI1.VIDEO.H264SVCE
include $(BUILD_HEAPTRACKED_SHARED_LIBRARY)


#
# libOMX.TI.DUCATI1.VIDEO.MPEG4E
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
	$(TI_OMXPROXY_COMMON_INCLUDES) \
	$(TI_OMXPROXY_ENCODER_INCLUDES)

LOCAL_SHARED_LIBRARIES := \
	$(TI_OMXPROXY_COMMON_SHARED_LIBRARIES) \
	$(TI_OMXPROXY_ENCODER_SHARED_LIBRARIES)

LOCAL_CFLAGS := \
	$(TI_OMXPROXY_COMMON_CFLAGS) \
	$(TI_OMXPROXY_ENCODER_CFLAGS)

LOCAL_SRC_FILES := omx_video_enc/src/omx_mpeg4_enc/src/omx_proxy_mpeg4enc.c

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libOMX.TI.DUCATI1.VIDEO.MPEG4E
include $(BUILD_HEAPTRACKED_SHARED_LIBRARY)


#
# libOMX.TI.DUCATI1.VIDEO.H264E.secure
#
include $(CLEAR_VARS)

LOCAL_C_INCLUDES := \
	$(TI_OMXPROXY_COMMON_INCLUDES) \
	$(TI_OMXPROXY_ENCODER_INCLUDES)

LOCAL_SHARED_LIBRARIES := \
	$(TI_OMXPROXY_COMMON_SHARED_LIBRARIES) \
	$(TI_OMXPROXY_ENCODER_SHARED_LIBRARIES)

LOCAL_CFLAGS := \
	$(TI_OMXPROXY_COMMON_CFLAGS) \
	$(TI_OMXPROXY_ENCODER_CFLAGS)

LOCAL_SRC_FILES := omx_video_enc/src/omx_h264_enc/src/omx_proxy_h264enc_secure.c

LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libOMX.TI.DUCATI1.VIDEO.H264E.secure
include $(BUILD_HEAPTRACKED_SHARED_LIBRARY)

FRAMEWORKS_MEDIA_BASE :=
