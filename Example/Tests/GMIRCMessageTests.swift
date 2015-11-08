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

import XCTest
@testable import GMIRCClient

class GMIRCMessageTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func test_welcomeMessage() {
        let msg = ":card.freenode.net 001 GMIRCClient :Welcome to the freenode Internet Relay Chat Network GMIRCClient"
        let ircMessage = GMIRCMessage(message: msg)
        
        XCTAssertNotNil(ircMessage!.prefix)
        XCTAssertNotNil(ircMessage!.prefix!.serverName)
        XCTAssertEqual(ircMessage!.prefix!.serverName!, "card.freenode.net")
        XCTAssertEqual(ircMessage!.command!, "001")
        
        XCTAssertEqual(ircMessage!.params!.msgTarget, "GMIRCClient")
        XCTAssertEqual(ircMessage!.params!.textToBeSent, "Welcome to the freenode Internet Relay Chat Network GMIRCClient")
    }
    
    func test_privateMessage() {
        let msg = ":eugenio79!~giuseppem@93-34-6-226.ip47.fastwebnet.it PRIVMSG GMIRCClient :Hi, I am another client"
        let ircMessage = GMIRCMessage(message: msg)
        
        XCTAssertNotNil(ircMessage!.prefix)
        XCTAssertNotNil(ircMessage!.prefix!.nickName)
        XCTAssertEqual(ircMessage!.prefix!.nickName!, "eugenio79")
        XCTAssertNotNil(ircMessage!.command!, "PRIVMSG")
        
        XCTAssertNotNil(ircMessage!.params)
        XCTAssertEqual(ircMessage!.params!.msgTarget, "GMIRCClient")
        XCTAssertEqual(ircMessage!.params!.textToBeSent, "Hi, I am another client")
    }

}
