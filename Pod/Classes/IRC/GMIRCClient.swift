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

public class GMIRCClient: NSObject {
    
    public weak var delegate: GMIRCClientDelegate?
    
    private enum REPLY: String {
        case WELCOME = "001"
    }
    
    private var _socket: GMSocketProtocol!
    private var _nickName: String! = ""
    private var _user: String! = ""
    private var _realName: String! = ""
    
    /// true when a I registered successfully (user and nick)
    private var _connectionRegistered = false
    
    /// true when waiting for registration response
    private var _waitingForRegistration = false
    
    /// true when received the welcome message from the server
    private var _ready = false
    
    /// each IRC message should end with this sequence
    private let ENDLINE = "\r\n"
    
    required public init(socket: GMSocketProtocol) {
        
        super.init()
        
        _socket = socket
        _socket!.delegate = self
    }
}

// MARK: - GMIRCClientProtocol
extension GMIRCClient: GMIRCClientProtocol {
    
    public func host() -> String {
        return _socket.host
  }
    
    public func port() -> Int {
        return _socket.port
    }
    
    public func register(nickName: String, user: String, realName: String) {
        _nickName = nickName
        _user = user
        _realName = realName
        
        _socket.delegate = self
        _socket.open()
    }
    
    public func join(channel: String) {
        guard !channel.isEmpty && channel.hasPrefix("#") else {
            return
        }
        _sendCommand("JOIN \(channel)")
    }
    
    public func sendMessageToNickName(message: String, nickName: String) {
        guard !nickName.hasPrefix("#") else {
            print("Invalid nickName")
            return
        }
        _sendCommand("PRIVMSG \(nickName) :\(message)")
    }
    
    public func sendMessageToChannel(message: String, channel: String) {
        guard channel.hasPrefix("#") else {
            print("Invalid channel")
            return
        }
        _sendCommand("PRIVMSG \(channel) :\(message)")
    }
}

// MARK: - SocketDelegate
extension GMIRCClient: GMSocketDelegate {
    
    public func didOpen() {
        print("[DEBUG] Socket opened")
    }
    
    public func didReadyToSendMessages() {
        
        if !_connectionRegistered && !_waitingForRegistration {
            
            _waitingForRegistration = true
            
            _sendCommand("NICK \(_nickName)")
            _sendCommand("USER \(_user) 0 * : \(_realName)")
        }
    }
    
    
    public func didReceiveMessage(msg: String) {
        
        print("\(msg)")
        
        let msgList = msg.componentsSeparatedByString(ENDLINE)
        for line in msgList {
            if line.hasPrefix("PING") {
                _pong(msg)
            } else {
                _handleMessage(line)
            }
        }
    }
    
    public func didClose() {
        print("Socket connection closed")
        
        _connectionRegistered = false
    }
}

// MARK: - private
private extension GMIRCClient {
    
    func _sendCommand(command: String) {
        let msg = command + ENDLINE
        _socket.sendMessage(msg)
    }
    
    func _pong(msg: String) {
        let token = msg.stringByReplacingOccurrencesOfString("PING :", withString: "").stringByReplacingOccurrencesOfString(ENDLINE, withString: "")
        
        _connectionRegistered = true    // When I receive the first PING I suppose my registration is done
        _waitingForRegistration = false
        
        _sendCommand("PONG \(token)")
    }
    
    func _handleMessage(msg: String) {
        
        let ircMsg = GMIRCMessage(message: msg)

        guard ircMsg != nil else {
//            print("Can't parse message: \(msg)")
            return
        }
        
        switch ircMsg!.command! {
        case "001":
            _ready = true
            delegate?.didWelcome()
        case "JOIN":
            delegate?.didJoin(ircMsg!.params!.unparsed!)
        case "PRIVMSG":
            delegate?.didReceivePrivateMessage(ircMsg!.params!.textToBeSent!, from: ircMsg!.prefix!.nickName!)
        default:
//            print("Message not handled: \(msg)")
            break;
        }
    }
}