#include "USBDevice.h"

USBDevice::USBDevice(const std::string& path) 
    : mMediaPath(path), mState(UnmountedState) 
{
   
}

USBDevice::~USBDevice() {
    
}

std::string USBDevice::getMediaPath() const {
    return mMediaPath;
}

void USBDevice::setMediaPath(const std::string& mediaPath) {
    mMediaPath = mediaPath;
}

USBDevice::DeviceState USBDevice::getState() const {
    return mState;
}

void USBDevice::setState(DeviceState state) {
    mState = state;
    
    std::string stateName;
    switch (state) {
        case IdleState: stateName = "Idle"; break;
        case UnmountedState: stateName = "Unmounted"; break;
        case MountedState: stateName = "Mounted"; break;
        case ReadyState: stateName = "Ready"; break;
    }
    std::cout << "[USBDevice] State changed to: " << stateName << std::endl;
}