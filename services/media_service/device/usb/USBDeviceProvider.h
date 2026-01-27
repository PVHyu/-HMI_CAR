#ifndef USB_DEVICE_PROVIDER_H
#define USB_DEVICE_PROVIDER_H

#include "USBDevice.h"
#include <libudev.h>
#include <thread>
#include <atomic>
#include <vector>
#include <string>
#include <functional> 

class USBDeviceProvider {
public:
    static USBDeviceProvider* getInstance();
    void startWatch();
    USBDevice* getDevice() const { return mDevice; }

   
    using UsbScanCallback = std::function<void(const std::vector<std::string>&)>;
    
 
    void setScanCallback(UsbScanCallback cb);

private:
    USBDeviceProvider();
    ~USBDeviceProvider();
    void watchLoop(); 
    bool performMount(const std::string& devPath);
    void scanFiles();

    static USBDeviceProvider* m_instance;
    USBDevice* mDevice = nullptr;
    
    UsbScanCallback mCallback;

    struct udev* udev_ctx;
    struct udev_monitor* udev_mon;
    std::thread mThread;
    std::atomic<bool> mRunning;
};

#endif