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

/// An IRC message prefix
public class GMIRCMessagePrefix: NSObject {
    
    private(set) var nickName: String?
    private(set) var serverName: String?
    
    /// @param prefix e.g. ":eugenio79!~giuseppem@93-34-6-226.ip47.fastwebnet.it"
    init?(prefix: String) {
        
        super.init()
        
        var idx = prefix.characters.indexOf(":")  // an IRC prefix should start with ":"
        
        guard idx != nil else {
            return nil
        }
        
        let remainingPrefix = prefix.substringFromIndex(idx!.successor())   // skipping the ":"
        
        idx = remainingPrefix.characters.indexOf("!")
        
        if idx != nil {
            nickName = remainingPrefix.substringToIndex(idx!)
        } else {
            serverName = remainingPrefix
        }
    }
}