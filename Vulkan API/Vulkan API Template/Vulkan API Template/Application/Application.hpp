//
//  Application.hpp
//  Vulkan API Template
//
//  Created by Dimka Novikov on 17.05.2021.
//

#ifndef Application_hpp
#define Application_hpp

#pragma once


// MARK: - Import section

//#include <vulkan/vulkan.h>
#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>


#include <iostream>
#include <stdexcept>
#include <cstdlib>


#define WINDOW_WIDTH  800
#define WINDOW_HEIGHT 600





struct Version {
    uint8_t major;
    uint8_t minor;
    uint8_t patch;
};




// MARK: - Application class
class Application final {
    // Variables and constants
private:
    Version version;
    GLFWwindow *window;
    VkInstance instance;
//public:
    
    
    
    // private functions
private:
    void initWindow();
    void initVulkan();
    
    void createInstance();
    
    void mainLoop();
    void cleanup();
    
    
    
    // public functions (constructor, destructor and methods)
public:
    Application();
    ~Application();
    
    
    
    void run();
    void getVersion();
};






#endif /* Application_hpp */
