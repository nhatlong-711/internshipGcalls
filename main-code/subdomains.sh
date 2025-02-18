# Danh sách các thư mục chứa mã nguồn
SOURCE_DIRS=(
    "./source/api-management"
    "./source/mobile-service"
    "./source/webphone-service"
    "./source/integration-manager"
    "./source/pbxlog-service"
)

# Đường dẫn đến file CSV chứa danh sách IP
IP_FILE="./input/domains.csv"
# Đường dẫn đến file CSV lưu kết quả
OUTPUT_FILE="./output/domainsResult.csv"

# Ghi tiêu đề cột (header) vào file CSV
echo "IP,Repo,Path,Filename,Type,Line" > "$OUTPUT_FILE"

# Hàm tìm các IP trong từng file
scan_files_for_ips() {
    local ip="$1"

    # Duyệt qua từng file trong thư mục và tìm kiếm IP
    grep -rnw "$ip" "${SOURCE_DIRS[@]}" 2>/dev/null | while read -r line; do
        # Tách thông tin từ kết quả grep
        file_path=$(echo "$line" | cut -d: -f1)  # Đường dẫn file
        line_number=$(echo "$line" | cut -d: -f2)  # Số dòng
        filename=$(basename "$file_path")  # Tên file
        filetype="${filename##*.}"  # Định dạng file

        # Xác định repo từ đường dẫn file
        repo=""
        for dir in "${SOURCE_DIRS[@]}"; do
            if [[ "$file_path" == "$dir"* ]]; then
                repo=$(basename "$dir")
                break
            fi
        done

        # Ghi kết quả vào file CSV
        echo "$ip,$repo,$file_path,$filename,$filetype,$line_number" >> "$OUTPUT_FILE"
    done
}

# Đọc danh sách IP từ file CSV và thực hiện tìm kiếm trong từng thư mục
while IFS=',' read -r ip; do
    # Bỏ qua các dòng trống trong file CSV
    if [[ -n "$ip" ]]; then
        scan_files_for_ips "$ip"
    fi
done < "$IP_FILE"
