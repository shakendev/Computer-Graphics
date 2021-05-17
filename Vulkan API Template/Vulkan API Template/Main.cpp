//
//  Main.cpp
//  Vulkan API Template
//
//  Created by Dimka Novikov on 17.05.2021.
//


#include "Application/Application.hpp"


int main(int argc, char *argv[]) {
    
    Application app;
    
    app.getVersion();
    
    try {
        app.run();
    } catch (const std::exception &error) {
        std::cerr << error.what() << std::endl;
        return EXIT_FAILURE;
    }
    
    return EXIT_SUCCESS;
    
}
