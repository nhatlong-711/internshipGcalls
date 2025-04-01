# Danh sách các thư mục chứa mã nguồn
SOURCE_DIRS=(
    "./source/api-management"
    "./source/mobile-service"
    "./source/webphone-service"
    "./source/integration-manager"
    "./source/pbxlog-service"
)

# Đường dẫn đến file CSV chứa danh sách IP
IP_FILE="./input/threatscanPrivates.csv"
# Đường dẫn đến file CSV lưu kết quả
OUTPUT_FILE="./output/IPresult.csv"

# Ghi tiêu đề cột (header) vào file CSV
echo "IP,Path" > "$OUTPUT_FILE"

# Hàm tìm các IP trong từng file
scan_files_for_ips() {
    local ip="$1"

    # Duyệt qua từng file trong thư mục và tìm kiếm IP
    grep -rl "$ip" "${SOURCE_DIRS[@]}" 2>/dev/null | while read -r file; do
        # Đường dẫn đầy đủ của file
        full_path=$(realpath "$file")
        # Ghi kết quả vào file CSV với hai cột IP và Path
        echo "$ip,$full_path" >> "$OUTPUT_FILE"
    done
}

# Đọc danh sách IP từ file CSV và thực hiện tìm kiếm trong từng thư mục
while IFS=',' read -r ip; do
    # Bỏ qua các dòng trống trong file CSV
    if [[ -n "$ip" ]]; then
        scan_files_for_ips "$ip"
    fi
done < "$IP_FILE"
