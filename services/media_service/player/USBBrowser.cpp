#include "USBBrowser.h"

USBBrowser::USBBrowser() {}
USBBrowser::~USBBrowser() {}

void USBBrowser::setPlaylist(const std::vector<USBFile>& files) {
    mPlaylist = files;
}

int USBBrowser::getTotalSongs() const {
    return mPlaylist.size();
}

USBFile USBBrowser::getFileAt(int index) {
    if (index < 0 || index >= mPlaylist.size()) {
        return USBFile("", ""); // Trả về file rỗng nếu index không hợp lệ
    }
    return mPlaylist[index];
}