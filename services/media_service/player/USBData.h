// player/USBData.h
#ifndef USB_DATA_H
#define USB_DATA_H

#include <string>

struct USBFile {
    std::string name;
    std::string path;
    // Sau này có thể thêm: duration, artist, album...
    
    USBFile(std::string n, std::string p) : name(n), path(p) {}
    USBFile() {} 
};

#endif