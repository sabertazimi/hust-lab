/*
 * main.cpp
 * Copyright (C) 2017 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include "HTTPServer.hpp"

int main(void) {
    DragonWeb::Server<DragonWeb::HTTP> server(12345, 4);

    server.resource["^/string/?$"]["POST"] = [](std::ostream & response, DragonWeb::Request & request) {
        std::stringstream ss;
        *(request.content) >> ss.rdbuf();
        std::string content = ss.str();
        response << "HTTP/1.1 200 OK\r\nContent-Length: " << content.length() << "\r\n\r\n" << content;
    };

    server.resource["^/info/?$"]["GET"] = [](std::ostream & response, DragonWeb::Request & request) {
        std::stringstream content_stream;
        content_stream << "<h1>Request:</h1>";
        content_stream << request.method << " " << request.path << " HTTP/" << request.http_version << "<br>";

        for(auto & header : request.header) {
            content_stream << header.first << ": " << header.second << "<br>";
        }

        content_stream.seekp(0, std::ios::end);

        response <<  "HTTP/1.1 200 OK\r\nContent-Length: " << content_stream.tellp() << "\r\n\r\n" << content_stream.rdbuf();
    };

    server.resource["^/match/([0-9a-zA-Z]+)/?$"]["GET"] = [](std::ostream & response, DragonWeb::Request & request) {
        std::string number=request.path_match[1];
        response << "HTTP/1.1 200 OK\r\nContent-Length: " << number.length() << "\r\n\r\n" << number;
    };

    server.default_resource["^/?(.*)$"]["GET"] = [](std::ostream & response, DragonWeb::Request & request) {
        std::string filename = "www/";
        std::string path = request.path_match[1];

        size_t last_pos = path.rfind(".");
        size_t current_pos = 0;
        size_t pos;
        while ((pos = path.find('.', current_pos)) != std::string::npos && pos != last_pos) {
            current_pos = pos;
            path.erase(pos, 1);
            last_pos--;
        }

        filename += path;
        std::ifstream ifs;
        if (filename.find('.') == std::string::npos) {
            if(filename[filename.length() - 1] != '/') {
                filename += '/';
            }

            filename += "index.html";
        }

        ifs.open(filename, std::ifstream::in);
        if (ifs) {
            ifs.seekg(0, std::ios::end);
            size_t length = ifs.tellg();

            ifs.seekg(0, std::ios::beg);
            response << "HTTP/1.1 200 OK\r\nContent-Length: " << length << "\r\n\r\n" << ifs.rdbuf();

            ifs.close();
        } else {
            std::string content = "Could not open file " + filename;
            response << "HTTP/1.1 400 Bad Request\r\nContent-Length: " << content.length() << "\r\n\r\n" << content;
        }
    };

    server.start();

    return 0;
}
