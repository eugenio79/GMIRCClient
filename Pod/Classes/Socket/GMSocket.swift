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

/// A simplet implementation of a socket protocol
public class GMSocket: NSObject {
    
    /// The host to which the socket will connect (e.g. "irc.freenode.net")
    private(set) public var host: String
    
    /// The port to which the socket will connect (e.g. 6667)
    private(set) public var port: Int
    
    public weak var delegate: GMSocketDelegate?
    
    private var inputStream: NSInputStream?
    private var outputStream: NSOutputStream?
    private var isOpen: Bool = false
    
    required public init(host: String, port: Int) {
        self.host = host
        self.port = port
    }
}

// MARK: - GMSocketProtocol
extension GMSocket: GMSocketProtocol {
    
    public func open() {
        
        guard !isOpen else {
            print("Socket already open")
            return
        }
        
        NSStream.getStreamsToHostWithName(host, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        inputStream!.scheduleInRunLoop(.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        outputStream!.scheduleInRunLoop(.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
        inputStream!.delegate = self
        outputStream!.delegate = self
        
        inputStream!.open()
        outputStream!.open()
    }
    
    public func close() {
        guard isOpen else {
            print("Socket already closed")
            return
        }
        
        inputStream!.delegate = nil
        outputStream!.delegate = nil
        
        inputStream!.close()
        outputStream!.close()
        
        isOpen = false
    }
    
    public func sendMessage(message: String) {
        
        guard isOpen else {
            print("Can't send message: socket is closed")
            return
        }
        
        let data = NSData(data: message.dataUsingEncoding(NSASCIIStringEncoding)!)
        let buffer = UnsafePointer<UInt8>(data.bytes)
        
        outputStream!.write(buffer, maxLength: data.length)
    }
}

// MARK: - NSStreamDelegate
extension GMSocket: NSStreamDelegate {
    
    public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        
        switch eventCode {
        case NSStreamEvent.None:
            print("Socket event: None")
        case NSStreamEvent.OpenCompleted:
            _openCompleted()
        case NSStreamEvent.HasBytesAvailable:
            _hasBytesAvailable(aStream)
        case NSStreamEvent.HasSpaceAvailable:
            _hasSpaceAvailable()
        case NSStreamEvent.ErrorOccurred:
            print("Socket: unknown error")
        case NSStreamEvent.EndEncountered:
            _endEncountered(aStream)
        default:
            print("Unknown socket event")
        }
    }
}

// MARK: - private
private extension GMSocket {
    
    func _openCompleted() {
        isOpen = true
        delegate?.didOpen()
    }
    
    func _hasBytesAvailable(aStream: NSStream) {
        
        guard aStream == inputStream else {
            print("Received bytes aren't for my inputStream")
            return
        }
        
        var buffer = [UInt8](count: 1024, repeatedValue: 0)
        while inputStream!.hasBytesAvailable {
            let len = inputStream!.read(&buffer, maxLength: 1024)
            if len > 0 {
                let output = NSString(bytes: buffer, length: len, encoding: NSASCIIStringEncoding)
                if output != nil && delegate != nil {
                    delegate!.didReceiveMessage(output! as String)
                }
            }
        }
    }
    
    func _hasSpaceAvailable() {
        delegate?.didReadyToSendMessages()
    }
    
    func _endEncountered(aStream: NSStream) {
        aStream.close()
        aStream.removeFromRunLoop(.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        delegate?.didClose()
    }
}