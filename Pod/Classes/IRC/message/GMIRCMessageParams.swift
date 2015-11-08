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

/// Encapsulates an IRC message params
public class GMIRCMessageParams: NSObject {
    
    /// Here I put everything I'm not still able to parse
    private(set) var unparsed: String?
    
    /// e.g. the target of a PRIVMSG
    private(set) var msgTarget: String?
    
    /// e.g. the the text of a PRIVMSG
    private(set) var textToBeSent: String?
    
    /// @param stringToParse e.g. "eugenio_ios :Hi, I am Eugenio too"
    init?(stringToParse: String) {
        
        super.init()
        
        var idx = stringToParse.characters.indexOf(" ")
        
        if idx == nil {
            unparsed = stringToParse
            return
        }
        
        msgTarget = stringToParse.substringToIndex(idx!)
        
        let remaining = stringToParse.substringFromIndex(idx!.successor())
        
        idx = remaining.characters.indexOf(":")
        
        if idx == nil {
            unparsed = remaining
            return
        }
        
        textToBeSent = remaining.substringFromIndex(idx!.successor())
    }
}