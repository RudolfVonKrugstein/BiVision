project(BiVision)
cmake_minimum_required(VERSION 2.8)
aux_source_directory(. SRC_LIST)
aux_source_directory(./gui_builder SRC_LIST)

ADD_DEFINITIONS(
    -std=c++11)

find_package(wxWidgets COMPONENTS core base REQUIRED)
include( "${wxWidgets_USE_FILE}" )

if(WIN32)
  set(SRCS ${SRCS} minimal.rc)
endif(WIN32)

add_executable(${PROJECT_NAME} ${SRC_LIST})

target_link_libraries(${PROJECT_NAME} ${wxWidgets_LIBRARIES})
