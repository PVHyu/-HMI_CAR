#ifndef USB_BROWSER_H
#define USB_BROWSER_H

#include <vector>
#include "USBData.h"

class USBBrowser {
public:
    USBBrowser();
    ~USBBrowser();

    void setPlaylist(const std::vector<USBFile>& files); 
    
    int getTotalSongs() const;
    USBFile getFileAt(int index);

private:
    std::vector<USBFile> mPlaylist;
};

#endif