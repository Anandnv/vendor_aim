PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_PROPERTY_OVERRIDES += \
    keyguard.no_require_sim=true \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.com.android.wifi-watchlist=GoogleGuest \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dateformat=MM-dd-yyyy \
    ro.com.android.dataroaming=false

PRODUCT_PROPERTY_OVERRIDES += \
    ro.build.selinux=1

# Disable excessive dalvik debug messages
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.debug.alloc=0

# Backup tool
PRODUCT_COPY_FILES += \
    vendor/aim/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/aim/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/aim/prebuilt/common/bin/50-aim.sh:system/addon.d/50-aim.sh

# Backup services whitelist
PRODUCT_COPY_FILES += \
    vendor/aim/config/permissions/backup.xml:system/etc/sysconfig/backup.xml

# Signature compatibility validation
PRODUCT_COPY_FILES += \
    vendor/aim/prebuilt/common/bin/otasigcheck.sh:install/bin/otasigcheck.sh

# Aim-specific init file
PRODUCT_COPY_FILES += \
    vendor/aim/prebuilt/common/etc/init.local.rc:root/init.aim.rc

# Copy LatinIME for gesture typing
PRODUCT_COPY_FILES += \
    vendor/aim/prebuilt/common/lib/libjni_latinimegoogle.so:system/lib/libjni_latinimegoogle.so

# SELinux filesystem labels
PRODUCT_COPY_FILES += \
    vendor/aim/prebuilt/common/etc/init.d/50selinuxrelabel:system/etc/init.d/50selinuxrelabel

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Don't export PS1 in /system/etc/mkshrc.
PRODUCT_COPY_FILES += \
    vendor/aim/prebuilt/common/etc/mkshrc:system/etc/mkshrc \
    vendor/aim/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf

# AIM-specific startup services
PRODUCT_COPY_FILES += \
    vendor/aim/prebuilt/common/etc/init.d/00banner:system/etc/init.d/00banner \
    vendor/aim/prebuilt/common/etc/init.d/90userinit:system/etc/init.d/90userinit \
    vendor/aim/prebuilt/common/bin/sysinit:system/bin/sysinit

# Required packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    Development \
    SpareParts \
    LockClock \
    su

# Optional packages
PRODUCT_PACKAGES += \
    Basic \
    LiveWallpapersPicker \
    PhaseBeam

# Include explicitly to work around GMS issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full \
    librsjni

# AudioFX
PRODUCT_PACKAGES += \
    AudioFX

# Extra Optional packages
PRODUCT_PACKAGES += \
    Calculator \
    LatinIME \
    BluetoothExt 

# Extra tools
PRODUCT_PACKAGES += \
    openvpn \
    e2fsck \
    mke2fs \
    tune2fs \
    fsck.exfat \
    mkfs.exfat \
    ntfsfix \
    ntfs-3g

# Custom off-mode charger
ifneq ($(WITH_CM_CHARGER),false)
PRODUCT_PACKAGES += \
    charger_res_images \
    cm_charger_res_images \
    font_log.png \
    libhealthd.cm
endif

# Stagefright FFMPEG plugin
PRODUCT_PACKAGES += \
    libffmpeg_extractor \
    libffmpeg_omx \
    media_codecs_ffmpeg.xml

PRODUCT_PROPERTY_OVERRIDES += \
    media.sf.omx-plugin=libffmpeg_omx.so \
    media.sf.extractor-plugin=libffmpeg_extractor.so

# easy way to extend to add more packages
-include vendor/extra/product.mk

PRODUCT_PACKAGE_OVERLAYS += vendor/aim/overlay/common

# Versioning System
# aim first version.
PRODUCT_VERSION_MAJOR = System-V3
PRODUCT_VERSION_MINOR = 0
PRODUCT_VERSION_MAINTENANCE = 0
AIM_POSTFIX := -$(shell date +"%Y%m%d-%H%M")
ifdef AIM_BUILD_EXTRA
    AIM_POSTFIX := -$(AIM_BUILD_EXTRA)
endif

ifndef AIM_BUILD_TYPE
    AIM_BUILD_TYPE := UNOFFICIAL
endif

# Set all versions
AIM_VERSION := AIM-$(AIM_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(AIM_BUILD_TYPE)$(AIM_POSTFIX)
AIM_MOD_VERSION := AIM-$(AIM_BUILD)-$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE)-$(AIM_BUILD_TYPE)$(AIM_POSTFIX)

PRODUCT_PROPERTY_OVERRIDES += \
    BUILD_DISPLAY_ID=$(BUILD_ID) \
    aim.ota.version=$(PRODUCT_VERSION_MAJOR).$(PRODUCT_VERSION_MINOR).$(PRODUCT_VERSION_MAINTENANCE) \
    ro.aim.version=$(AIM_VERSION) \
    ro.modversion=$(AIM_MOD_VERSION) \
    ro.aim.buildtype=$(AIM_BUILD_TYPE)

EXTENDED_POST_PROCESS_PROPS := vendor/aim/tools/aim_process_props.py
