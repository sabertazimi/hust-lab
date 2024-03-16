/*
 * HTTPServer.hpp
 * Copyright (C) 2017 sabertazimi <sabertazimi@avalon>
 *
 * Distributed under terms of the MIT license.
 */

#ifndef HTTP_SERVER_HPP
#define HTTP_SERVER_HPP

#include "BaseServer.hpp"

namespace DragonWeb {
    typedef boost::asio::ip::tcp::socket HTTP;
    template<>
    class Server<HTTP> : public BaseServer<HTTP> {
    public:
        Server(unsigned short port, size_t num_threads = 1) :
            BaseServer<HTTP>::BaseServer(port, num_threads) {}
    private:
        void accept(void) {
            auto socket = std::make_shared<HTTP>(m_io_service);
            acceptor.async_accept(*socket, [this, socket](const boost::system::error_code & ec) {
                accept();
                if (!ec) {
                    process_request_and_respond(socket);
                }
            });
        }
    };
}

#endif

