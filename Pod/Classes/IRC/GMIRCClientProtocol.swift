// Copyright © 2015 Giuseppe Morana aka Eugenio
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public protocol GMIRCClientProtocol: NSObjectProtocol {
    
    weak var delegate: GMIRCClientDelegate? { get set }
    
    init(socket: GMSocketProtocol)
    
    func host() -> String
    func port() -> Int
    
    /// In order to start an IRC session, you'd provide at least a nick name and a real name
    func register(nickName: String, user: String, realName: String)
    
    /// Join a channel / chat room
    func join(channel: String)
    
    /// Send a private message to a specific user (identified by its nickname)
    /// @param message The message to send
    /// @param nickName The nickname of the recipient (e.g. "john")
    func sendMessageToNickName(message: String, nickName: String)
    
    /// Send a message to a specific channel
    /// @param message The message to send
    /// @param channel The target channel (e.g. "#test")
    func sendMessageToChannel(message: String, channel: String)
}