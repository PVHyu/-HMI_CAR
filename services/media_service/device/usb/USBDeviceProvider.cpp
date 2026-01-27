#include "USBDeviceProvider.h"
#include <poll.h>
#include <cstring>
#include <iostream>
#include <sys/stat.h>
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>

const std::string MOUNT_POINT = "/mnt/usb_data";

USBDeviceProvider* USBDeviceProvider::m_instance = nullptr;

USBDeviceProvider* USBDeviceProvider::getInstance() {
    if (m_instance == nullptr) {
        m_instance = new USBDeviceProvider();
    }
    return m_instance;
}

USBDeviceProvider::USBDeviceProvider() : mRunning(false) {
    udev_ctx = udev_new();
}

USBDeviceProvider::~USBDeviceProvider() {
    mRunning = false;
    if (mThread.joinable()) mThread.join();
    if (udev_mon) udev_monitor_unref(udev_mon);
    if (udev_ctx) udev_unref(udev_ctx);
    std::string cmd = "umount " + MOUNT_POINT + " 2>/dev/null";
    system(cmd.c_str());
}

void USBDeviceProvider::setScanCallback(UsbScanCallback cb) {
    mCallback = cb;
}

bool USBDeviceProvider::performMount(const std::string& devPath) {
    struct stat st = {0};
    if (stat(MOUNT_POINT.c_str(), &st) == -1) mkdir(MOUNT_POINT.c_str(), 0777);
    
    std::string cleanCmd = "umount -f " + MOUNT_POINT + " 2>/dev/null";
    system(cleanCmd.c_str());

    std::string cmd = "mount " + devPath + " " + MOUNT_POINT;
    return (system(cmd.c_str()) == 0);
}

void USBDeviceProvider::scanFiles() {
    DIR *dir;
    struct dirent *ent;
    std::vector<std::string> playlist;

    if ((dir = opendir(MOUNT_POINT.c_str())) != NULL) {
        while ((ent = readdir(dir)) != NULL) {
            std::string name = ent->d_name;
            if (name == "." || name == "..") continue;
            
            if (name.length() > 4 && name.substr(name.length() - 4) == ".mp3") {
                 std::string fullPath = MOUNT_POINT + "/" + name;
                 playlist.push_back(fullPath);
            }
        }
        closedir(dir);
    }
    
    if (!playlist.empty()) {
        std::cout << ">>> [Provider] Quét được " << playlist.size() << " bài. Đang gửi cho Engine..." << std::endl;
        if (mCallback) {
            mCallback(playlist); 
        }
    } else {
        std::cout << ">>> [Provider] USB rỗng hoặc không có file mp3." << std::endl;
    }
}

void USBDeviceProvider::startWatch() {
    udev_mon = udev_monitor_new_from_netlink(udev_ctx, "udev");
    udev_monitor_filter_add_match_subsystem_devtype(udev_mon, "block", "partition");
    udev_monitor_enable_receiving(udev_mon);

    mRunning = true;
    mThread = std::thread(&USBDeviceProvider::watchLoop, this);
}

void USBDeviceProvider::watchLoop() {
    int fd = udev_monitor_get_fd(udev_mon);
    struct pollfd fds[1];
    fds[0].fd = fd;
    fds[0].events = POLLIN;

    while (mRunning) {
        int ret = poll(fds, 1, 1000);
        if (ret > 0 && (fds[0].revents & POLLIN)) {
            struct udev_device* dev = udev_monitor_receive_device(udev_mon);
            if (dev) {
                const char* action = udev_device_get_action(dev);
                const char* devnode = udev_device_get_devnode(dev);

                if (action && strcmp(action, "add") == 0) {
                    std::cout << "[Provider] Detect ADD: " << devnode << std::endl;
                    if (mDevice) delete mDevice;
                    mDevice = new USBDevice(devnode);
                    mDevice->setState(USBDevice::MountedState);

                    if (performMount(devnode)) {
                         scanFiles();
                         mDevice->setState(USBDevice::ReadyState);
                    }
                }
                else if (action && strcmp(action, "remove") == 0) {
                     std::cout << "[Provider] Detect REMOVE: " << devnode << std::endl;
                     if (mDevice) { delete mDevice; mDevice = nullptr; }
                }
                udev_device_unref(dev);
            }
        }
    }
}