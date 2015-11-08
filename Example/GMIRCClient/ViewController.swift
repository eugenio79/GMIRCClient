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

import UIKit
import GMIRCClient

class ViewController: UIViewController {
    
    var irc: GMIRCClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let socket = GMSocket(host: "irc.freenode.net", port: 6667)
        irc = GMIRCClient(socket: socket)
        irc.delegate = self
        irc.register("eugenio_ios", user: "eugenio_ios", realName: "Giuseppe Morana")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: GMIRCClientDelegate {
    
    func didWelcome() {
        print("Received welcome message - ready to join a chat room")
        irc.join("#test")
    }
    
    func didJoin(channel: String) {
        print("Joined chat room: \(channel)")
        
        irc.sendMessageToNickName("Hi, I'm eugenio_ios. Nice to meet you!", nickName: "eugenio79")
    }
    
    func didReceivePrivateMessage(text: String, from: String) {
        print("\(from): \(text)")
    }
}