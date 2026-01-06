#!/bin/bash

# 输出文件名
OUTPUT_FILE="project_code.md"

# 清空旧文件
> "$OUTPUT_FILE"

# 定义需要包含的文件或文件夹列表 (基于之前的筛选列表)
PATHS=(
    "docker/Dockerfile"
    "docker/Dockerfile_mid"
    "docker/nginx/nginx.conf"
    "docker-entrypoint.sh"
    "Dockerfile"
    "gen-reachability-metadata.sh"
    "jc.sh"
    "pom.xml"
    "README.md"
    "release-www.sh"
    "src/main/java/com/jmal/clouddisk/acpect"
    "src/main/java/com/jmal/clouddisk/annotation"
    "src/main/java/com/jmal/clouddisk/config"
    "src/main/java/com/jmal/clouddisk/controller"
    "src/main/java/com/jmal/clouddisk/dao"
    "src/main/java/com/jmal/clouddisk/exception"
    "src/main/java/com/jmal/clouddisk/interceptor"
    "src/main/java/com/jmal/clouddisk/JmalCloudApplication.java"
    "src/main/java/com/jmal/clouddisk/listener"
    "src/main/java/com/jmal/clouddisk/lucene"
    "src/main/java/com/jmal/clouddisk/media"
    "src/main/java/com/jmal/clouddisk/model"
    "src/main/java/com/jmal/clouddisk/ocr"
    "src/main/java/com/jmal/clouddisk/office"
    "src/main/java/com/jmal/clouddisk/oss"
    "src/main/java/com/jmal/clouddisk/service"
    "src/main/java/com/jmal/clouddisk/swagger"
    "src/main/java/com/jmal/clouddisk/util"
    "src/main/java/com/jmal/clouddisk/webdav"
    "src/main/resources/application.yml"
    "src/main/resources/application-dev.yml"
    "src/main/resources/application-migration.yml"
    "src/main/resources/application-mongodb.yml"
    "src/main/resources/application-mysql.yml"
    "src/main/resources/application-native.yml"
    "src/main/resources/application-pgsql.yml"
    "src/main/resources/application-prod.yml"
    "src/main/resources/application-sqlite.yml"
    "src/main/resources/application-test.yml"
    "src/main/resources/db"
    "src/main/resources/i18n"
    "src/main/resources/logback.xml"
    "src/main/resources/templates"
    "src/test/java/com/jmal/clouddisk"
    "upload.sh"
)

# 获取 Markdown 语言标识符的函数
get_lang() {
    case "$1" in
        *.java) echo "java" ;;
        *.xml) echo "xml" ;;
        *.yml|*.yaml) echo "yaml" ;;
        *.sql) echo "sql" ;;
        *.sh) echo "bash" ;;
        *.json) echo "json" ;;
        *.properties) echo "properties" ;;
        *.html) echo "html" ;;
        *.js) echo "javascript" ;;
        *.css) echo "css" ;;
        Dockerfile*) echo "dockerfile" ;;
        *) echo "" ;;
    esac
}

# 处理单个文件的函数
process_file() {
    local file_path="$1"

    # 跳过不存在的文件
    if [[ ! -f "$file_path" ]]; then
        return
    fi

    # 排除二进制文件（通过检查文件类型或扩展名）
    if [[ "$file_path" =~ \.(png|ico|gif|jpg|jpeg|ttf|woff|woff2|bmp|xdb|traineddata)$ ]]; then
        return
    fi

    echo "正在处理: $file_path"

    # 获取语言标识
    local lang=$(get_lang "$file_path")

    # 写入路径
    echo "$file_path" >> "$OUTPUT_FILE"
    # 写入代码块开头
    echo "\`\`\`$lang" >> "$OUTPUT_FILE"
    # 写入文件内容
    cat "$file_path" >> "$OUTPUT_FILE"
    # 写入换行和代码块结尾
    echo -e "\n\`\`\`\n" >> "$OUTPUT_FILE"
}

# 遍历初始列表
for item in "${PATHS[@]}"; do
    if [[ -d "$item" ]]; then
        # 如果是目录，递归查找该目录下所有文件并排序
        find "$item" -type f | sort | while read -r sub_file; do
            process_file "$sub_file"
        done
    else
        # 如果是文件，直接处理
        process_file "$item"
    fi
done

echo "完成！内容已保存至 $OUTPUT_FILE"