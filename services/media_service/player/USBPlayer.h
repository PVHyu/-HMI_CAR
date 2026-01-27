#ifndef USB_PLAYER_H
#define USB_PLAYER_H

#include <gst/gst.h>
#include <string>
#include <iostream>
#include <thread>
#include <atomic>
#include <functional>
#include <vector>
#include <algorithm>
#include <cstdint>
#include <random>
#include "USBBrowser.h" 

struct MediaInfo {
    std::string title;
    std::string artist;
    std::string album;
    int64_t duration = 0; // Tính bằng giây
};

class USBPlayer {
public:
    enum RepeatMode { NoRepeat, RepeatOne, RepeatList };

    static USBPlayer* getInstance();
    
    void setBrowser(USBBrowser* browser);
    void onPlaylistUpdated(); // Gọi khi có USB mới cắm vào

    void setShuffle(bool enable);
    void setRepeatMode(RepeatMode mode);

    void play(); 
    void pause();
    void resume();
    void stop();
    
    void next(bool byUser); 
    void previous();

    using EndOfStreamCallback = std::function<void()>;
    void setEndOfStreamCallback(EndOfStreamCallback cb);

    int64_t getPosition(); 
    int64_t getDuration();
    MediaInfo getMediaInfo();

private:
    USBPlayer();
    ~USBPlayer();
    
    void playFile(const std::string& filePath); 
    void busWatchLoop();

    static USBPlayer* m_instance;
    GstElement *mPipeline = nullptr;
    std::thread mBusThread;
    std::atomic<bool> mRunning;
    EndOfStreamCallback mEosCallback;

    USBBrowser* mBrowser = nullptr;
    int mCurrentIndex = 0;
    bool mIsShuffle = false;
    RepeatMode mRepeatMode = NoRepeat;
    
    std::vector<int> mPlayOrder; 
    void updatePlayOrder(); // Hàm cập nhật lại thứ tự index

    MediaInfo mCurrentMediaInfo; 
    void handleTags(GstMessage *msg); 
};

#endif