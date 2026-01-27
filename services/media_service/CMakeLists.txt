cmake_minimum_required(VERSION 3.13)
project(MediaService)

set(CMAKE_CXX_STANDARD 17)

find_package(PkgConfig REQUIRED)


pkg_check_modules(UDEV REQUIRED libudev)
pkg_check_modules(GSTREAMER REQUIRED gstreamer-1.0)


set(SOURCES
    main.cpp
    USBServiceEngine.cpp           
    device/usb/USBDevice.cpp
    device/usb/USBDeviceProvider.cpp
    player/USBPlayer.cpp          
    player/USBBrowser.cpp          
)


include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}             
    ${CMAKE_CURRENT_SOURCE_DIR}/device/usb
    ${CMAKE_CURRENT_SOURCE_DIR}/player
    ${CMAKE_CURRENT_SOURCE_DIR}/inf        
    ${UDEV_INCLUDE_DIRS}
    ${GSTREAMER_INCLUDE_DIRS}
)


add_executable(${PROJECT_NAME} ${SOURCES})


target_link_libraries(${PROJECT_NAME} PRIVATE
    ${UDEV_LIBRARIES}
    ${GSTREAMER_LIBRARIES}
    pthread
)