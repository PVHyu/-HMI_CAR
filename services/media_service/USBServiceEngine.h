#ifndef USB_SERVICE_ENGINE_H
#define USB_SERVICE_ENGINE_H

#include "device/usb/USBDeviceProvider.h"
#include "player/USBBrowser.h"
#include "player/USBPlayer.h"

class USBServiceEngine {
public:
    USBServiceEngine();
    ~USBServiceEngine();
    void initialize();
    
    void onPlayPause();
    void onNext(bool byUser);
    void onPrev();
    void onShuffle();
    void onRepeatMode();
    
    void onUSBPlugged(const std::vector<USBFile>& files);

private:
    USBBrowser mBrowser; 
};
#endif