if [ "$CONFIGURATION" == "Debug" ]; then
echo "Skipping debug"
exit 0;
fi

if [ "$EFFECTIVE_PLATFORM_NAME" == "-iphonesimulator" ]; then
echo "Skipping simulator build"
exit 0;
fi

version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}"`
build_num=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${CONFIGURATION_BUILD_DIR}/${INFOPLIST_PATH}"`
shopt -s extglob
build_num="${build_num##*( )}"
shopt -u extglob
versionid="${version}($build_num)"
echo $versionid

SRC_PATH=${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}
#SRC_PATH=${ARCHIVE_DSYMS_PATH}/${DWARF_DSYM_FILE_NAME}
RELATIVE_DEST_PATH=dSYM/${EXECUTABLE_NAME}.${versionid}.app.dSYM
DEST_PATH=${PROJECT_DIR}/${RELATIVE_DEST_PATH}
echo "moving ${SRC_PATH} to ${DEST_PATH}"

mkdir -p "${DEST_PATH}"  
cp -rf "${SRC_PATH}" "${DEST_PATH}"

# if [ -f ".git/config" ]; then
# git add "${RELATIVE_DEST_PATH}"
# git commit -m "Added dSYM file for ${BUILD_STYLE} build" "${RELATIVE_DEST_PATH}"
# fi