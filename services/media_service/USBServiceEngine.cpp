#include "USBServiceEngine.h"

USBServiceEngine::USBServiceEngine() {}
USBServiceEngine::~USBServiceEngine() {}

void USBServiceEngine::initialize() {
    std::cout << "[ServiceEngine] Init..." << std::endl;
    USBPlayer::getInstance()->setBrowser(&mBrowser);
    USBPlayer::getInstance()->setEndOfStreamCallback([this]() {  
        USBPlayer::getInstance()->next(false);
    });

    USBDeviceProvider::getInstance()->setScanCallback([this](const std::vector<std::string>& rawFiles) {
        std::vector<USBFile> fileObjects;
        for (const auto& path : rawFiles) {
            size_t lastSlash = path.find_last_of("/");
            std::string name = path.substr(lastSlash + 1);
            fileObjects.push_back(USBFile(name, path));
        }
        this->onUSBPlugged(fileObjects);
    });
    USBDeviceProvider::getInstance()->startWatch();
}

void USBServiceEngine::onUSBPlugged(const std::vector<USBFile>& files) {
    if (files.empty()) return;
    std::cout << "[Engine] Loading " << files.size() << " files..." << std::endl;
    mBrowser.setPlaylist(files);
    USBPlayer::getInstance()->onPlaylistUpdated();
    USBPlayer::getInstance()->play();
}

void USBServiceEngine::onPlayPause() {
    static bool isPlaying = true;
    if (isPlaying) {
        USBPlayer::getInstance()->pause(); isPlaying = false;
    } else {
        USBPlayer::getInstance()->resume(); isPlaying = true;
    }
}

void USBServiceEngine::onNext(bool byUser) {
    USBPlayer::getInstance()->next(byUser);
}

void USBServiceEngine::onPrev() {
    USBPlayer::getInstance()->previous();
}

void USBServiceEngine::onShuffle() {
    static bool s = false; s = !s;
    USBPlayer::getInstance()->setShuffle(s); // Gọi Player
}

void USBServiceEngine::onRepeatMode() {
    static int m = 0; m++; if(m>2) m=0;
    USBPlayer::getInstance()->setRepeatMode((USBPlayer::RepeatMode)m); // Gọi Player
}