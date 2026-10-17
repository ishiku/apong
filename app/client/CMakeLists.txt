add_executable(client src/main.cpp)

target_link_libraries(client PRIVATE game::gem)

game_project_settings(client)