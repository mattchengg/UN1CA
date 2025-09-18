if [[ "$SOURCE_API_LEVEL" == "$TARGET_API_LEVEL" ]]; then
    LOG "\033[0;33m! Nothing to do\033[0m"
    return 0
fi
