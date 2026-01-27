#include "USBPlayer.h"

USBPlayer* USBPlayer::m_instance = nullptr;

USBPlayer* USBPlayer::getInstance() {
    if (m_instance == nullptr) m_instance = new USBPlayer();
    return m_instance;
}

USBPlayer::USBPlayer() : mRunning(false) {
    gst_init(nullptr, nullptr);
    mPipeline = gst_element_factory_make("playbin", "usb-player");
    if (mPipeline) {
        mRunning = true;
        mBusThread = std::thread(&USBPlayer::busWatchLoop, this);
    }
}

USBPlayer::~USBPlayer() {
    stop(); mRunning = false;
    if (mBusThread.joinable()) mBusThread.join(); 
    if (mPipeline) gst_object_unref(mPipeline);
}

void USBPlayer::setBrowser(USBBrowser* browser) {
    mBrowser = browser;
}

void USBPlayer::onPlaylistUpdated() {
    mCurrentIndex = 0;
    updatePlayOrder(); 
}

void USBPlayer::updatePlayOrder() {
    if (!mBrowser) return;
    int total = mBrowser->getTotalSongs(); 
    mPlayOrder.clear();
    for(int i=0; i<total; ++i) mPlayOrder.push_back(i);

    if (mIsShuffle) {
        std::random_device rd;
        std::mt19937 g(rd());
        std::shuffle(mPlayOrder.begin(), mPlayOrder.end(), g);
    }
    mCurrentIndex = 0;
}

void USBPlayer::setShuffle(bool enable) {
    if (mIsShuffle == enable) return;
    mIsShuffle = enable;
    updatePlayOrder();
    std::cout << "[USBPlayer] Shuffle: " << (mIsShuffle ? "ON" : "OFF") << std::endl;
}

void USBPlayer::setRepeatMode(RepeatMode mode) {
    mRepeatMode = mode;
}

void USBPlayer::next(bool byUser) {
    if (!mBrowser || mPlayOrder.empty()) return;
    if (!byUser && mRepeatMode == RepeatOne) {
        play(); 
        return;
    }

    mCurrentIndex++;

    if (mCurrentIndex >= mPlayOrder.size()) {
        if (mRepeatMode == RepeatList) {
            mCurrentIndex = 0; 
        } else {
            mCurrentIndex = mPlayOrder.size() - 1; 
            if (!byUser) {
                stop();
                return;
            }
        }
    }
    play(); 
}

void USBPlayer::previous() {
    if (!mBrowser || mPlayOrder.empty()) return;

    if (mCurrentIndex > 0) mCurrentIndex--;
    else if (mRepeatMode == RepeatList) mCurrentIndex = mPlayOrder.size() - 1;
    else mCurrentIndex = 0;
    
    play();
}

void USBPlayer::play() { 
    if (!mBrowser || mPlayOrder.empty()) return;
    
    int realIndex = mPlayOrder[mCurrentIndex];
    USBFile file = mBrowser->getFileAt(realIndex);
    
    if (!file.path.empty()) {
        playFile(file.path);
    }
}

void USBPlayer::playFile(const std::string& filePath) {
    if (!mPipeline) return;
    gst_element_set_state(mPipeline, GST_STATE_NULL);
    std::string uri = "file://" + filePath;
    g_object_set(mPipeline, "uri", uri.c_str(), nullptr); 
    mCurrentMediaInfo = MediaInfo(); 
    mCurrentMediaInfo.title = filePath;
    gst_element_set_state(mPipeline, GST_STATE_PLAYING);
    std::cout << "[USBPlayer] ▶ Playing (" << (mCurrentIndex+1) << "): " << filePath << std::endl;
}

void USBPlayer::pause() { gst_element_set_state(mPipeline, GST_STATE_PAUSED); } 
void USBPlayer::stop() { gst_element_set_state(mPipeline, GST_STATE_NULL); }  
void USBPlayer::setEndOfStreamCallback(EndOfStreamCallback cb) { mEosCallback = cb; }

void USBPlayer::resume() { 
    if (mPipeline) {
        gst_element_set_state(mPipeline, GST_STATE_PLAYING);
        std::cout << "[USBPlayer] ▶ Resumed" << std::endl;
    }
}

int64_t USBPlayer::getPosition() {
    if (!mPipeline) return 0;

    gint64 current = 0;
    if (gst_element_query_position(mPipeline, GST_FORMAT_TIME, &current)) {
        return current / GST_SECOND; // Đổi ra giây
    }
    return 0;
}

int64_t USBPlayer::getDuration() {
    if (!mPipeline) return 0;

    gint64 duration = 0;
    if (gst_element_query_duration(mPipeline, GST_FORMAT_TIME, &duration)) {
        mCurrentMediaInfo.duration = duration / GST_SECOND;
        return mCurrentMediaInfo.duration;
    }
    return 0;
}

MediaInfo USBPlayer::getMediaInfo() {
    getDuration(); 
    return mCurrentMediaInfo;
}

void USBPlayer::busWatchLoop() {
    GstBus *bus = gst_element_get_bus(mPipeline);
    while (mRunning) {
        GstMessage *msg = gst_bus_timed_pop_filtered(bus, 100 * GST_MSECOND,
            (GstMessageType)(GST_MESSAGE_EOS | GST_MESSAGE_ERROR | GST_MESSAGE_TAG));

        if (msg != nullptr) {
            switch (GST_MESSAGE_TYPE(msg)) {
                case GST_MESSAGE_EOS:
                    if (mEosCallback) mEosCallback();
                    break;
                case GST_MESSAGE_ERROR:
                    std::cerr << "GStreamer Error!" << std::endl;
                    break;
                
                case GST_MESSAGE_TAG: {
                    GstTagList *tags = nullptr;
                    gst_message_parse_tag(msg, &tags);
                    
                    gchar *artist = nullptr;
                    gchar *title = nullptr;
                    gchar *album = nullptr;


                    if (gst_tag_list_get_string(tags, GST_TAG_TITLE, &title)) {
                        mCurrentMediaInfo.title = std::string(title);
                        g_free(title);
                    }
                    if (gst_tag_list_get_string(tags, GST_TAG_ARTIST, &artist)) {
                        mCurrentMediaInfo.artist = std::string(artist);
                        g_free(artist);
                    }
                    if (gst_tag_list_get_string(tags, GST_TAG_ALBUM, &album)) {
                        mCurrentMediaInfo.album = std::string(album);
                        g_free(album);
                    }
                    
                    std::cout << ">>> Metadata Updated: " << mCurrentMediaInfo.title 
                              << " - " << mCurrentMediaInfo.artist << std::endl;
                              
                    gst_tag_list_unref(tags);
                    break;
                }
                default: break;
            }
            gst_message_unref(msg);
        }
    }
    gst_object_unref(bus);
}