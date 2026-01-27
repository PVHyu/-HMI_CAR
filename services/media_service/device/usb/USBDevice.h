#ifndef USB_DEVICE_H
#define USB_DEVICE_H

#include <string>
#include <iostream>


class USBDevice {
public:
    
    enum DeviceState {
        IdleState,
        UnmountedState,
        MountedState,
        ReadyState
    };

    USBDevice(const std::string& path);
    
    virtual ~USBDevice();

    std::string getMediaPath() const;

    void setMediaPath(const std::string& mediaPath);

    DeviceState getState() const;
    void setState(DeviceState state);

private:
    std::string mMediaPath;
    DeviceState mState;
};

#endif 