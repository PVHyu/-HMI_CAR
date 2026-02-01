# HMI_CAR
Project gồm backend và frontend
Xử lý backend, cụ thể là phần service cho usb (scan và detect usb mỗi khi hot plug ) đã hoàn thành.
Phần protocol (grpc) chưa có để giao tiếp giữa frontend và backend
Phần frontend chưa hoàn thiện

=======================================================

Để chạy thử phần Backend:
1. Open project
2. cd services/media_service/build
3. Chạy lệnh Cmake ..
4. Tiếp theo chạy lệnh make
5. Chạy lệnh sudo -E env XDG_RUNTIME_DIR=/run/user/$(id -u) ./MediaService
6. Cắm USB để scan file nhạc ở định dạng .mp3
7. Khởi chạy thành công

Lưu ý: Có thể lần chạy đầu tiên khi pull code về máy sẽ bị lỗi vì chưa có những thư viện, hãy kiểm tra file CMakeLists.txt để bổ sung thư viện
