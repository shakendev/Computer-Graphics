//
//  Application.cpp
//  Vulkan API Template
//
//  Created by Dimka Novikov on 17.05.2021.
//


#include "Application.hpp"


Application::Application() {
    this -> version = {1, 0, 0};
}





void Application::initWindow() {
    glfwInit();
    
    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindowHint(GLFW_RESIZABLE, GLFW_FALSE);
    
    (this -> window) = glfwCreateWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Draw Triangle", nullptr, nullptr);
}



void Application::initVulkan() {
    this -> createInstance();
}



void Application::createInstance() {
    VkApplicationInfo appInfo = {};
    appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    appInfo.pApplicationName = "Draw Triangle";
    appInfo.applicationVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.pEngineName = "No Engine";
    appInfo.engineVersion = VK_MAKE_VERSION(1, 0, 0);
    appInfo.apiVersion = VK_API_VERSION_1_0;
}




void Application::mainLoop() {
    while (!glfwWindowShouldClose(this -> window)) {
        glfwPollEvents();
    }
}




void Application::cleanup() {
    glfwDestroyWindow(this -> window);
    glfwTerminate();
}




void Application::run() {
    this -> initWindow();
    this -> initVulkan();
    this -> mainLoop();
    this -> cleanup();
}


















void Application::getVersion() {
    printf("Current app ver. is: %u.%u.%u\n",
           (this -> version.major),
           (this -> version.minor),
           (this -> version.patch));
}



Application::~Application() {
    
}
