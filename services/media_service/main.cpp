#include "USBServiceEngine.h"
#include <iostream>
#include <limits> 

int main() {
    std::cout << "--- CAR HMI MEDIA SERVICE (Refactored) ---" << std::endl;

    // 1. Khởi tạo Engine (Nhạc trưởng)
    USBServiceEngine engine;
    engine.initialize(); 

    std::cout << "\n==============================================" << std::endl;
    std::cout << "   CONTROLLER (VIA ENGINE)                   " << std::endl;
    std::cout << "==============================================" << std::endl;
    std::cout << " [n] Next Song       (User Force Next)" << std::endl;
    std::cout << " [p] Previous Song" << std::endl;
    std::cout << " [k] Play/Pause" << std::endl;
    std::cout << " [s] Shuffle Toggle" << std::endl;
    std::cout << " [r] Repeat Mode" << std::endl;
    std::cout << " [q] Quit" << std::endl;
    std::cout << "==============================================" << std::endl;

    char cmd;
    while (true) {
        std::cout << "\nCommand > ";
        std::cin >> cmd;

        switch (cmd) {
            case 'n': 
                engine.onNext(true); // true = User bấm
                break;
            case 'p': 
                engine.onPrev(); 
                break;
            case 'k':
                engine.onPlayPause();
                break;
            case 's': 
                engine.onShuffle();
                break;
            case 'r': 
                engine.onRepeatMode(); // Engine tự xoay vòng mode
                break;
            case 'q': 
                return 0;
            default:
                std::cout << "Invalid command!" << std::endl;
        }
    }
    return 0;
}