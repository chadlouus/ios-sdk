/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import ObjectMapper

/// Helper extension to map from one type of object to another type
extension Mapper {
    
    // Maps an Object to a JSON string with the given header
    internal func toJSONString(object: N, header: String) -> String? {
        let json = toJSONString(object, prettyPrint: false)
        if let json = json {
            return "{ \"\(header)\": \(json) }"
        } else {
            return nil
        }
    }
    
    internal func myToJSONString(objects: [N]) -> String? {
        if (objects.count <= 0) {
            return nil
        }
        var o = "[";
        for (index, ele) in objects.enumerate() {
            if index > 0 {
                o += ", "
            }
            o += toJSONString(ele, prettyPrint: false)!
        }
        o += "]"
        return o
    }
    
    // Maps an array of Objects to a JSON string with the given header
    internal func toJSONString(objects: [N], header: String) -> String? {
        let json = myToJSONString(objects)
        if let json = json {
            return "{ \"\(header)\": \(json) }"
        } else {
            return nil
        }
    }
    
    // Maps an Object to a JSON string and represents it as NSData
    internal func toJSONData(object: N) -> NSData? {
        let json = toJSONString(object, prettyPrint: false)
        return json?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    // Maps an array of Objects to a JSON string and represents it as NSData
    internal func toJSONData(objects: [N]) -> NSData? {
        
        let json = myToJSONString(objects)
        return json?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    // Maps an Object to a JSON string with the given header and represents it as NSData
    internal func toJSONData(object: N, header: String) -> NSData? {
        let json = toJSONString(object, header: header)
        return json?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    // Maps an array of Objects to a JSON string with the given header and represents it as NSData
    internal func toJSONData(objects: [N], header: String) -> NSData? {
        let json = toJSONString(objects, header: header)
        return json?.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    // Maps an optional NSData object to an object that conforms to Mappable.
    internal func mapData(JSONData: NSData?, keyPath: String? = nil) -> N? {
        guard let JSONData = JSONData else {
            return nil
        }
        
        var JSON: AnyObject?
        do {
            JSON = try NSJSONSerialization.JSONObjectWithData(JSONData, options: .AllowFragments)
        } catch {
            return nil
        }
        
        var JSONToMap: AnyObject?
        if let JSON = JSON, keyPath = keyPath where !keyPath.isEmpty {
            JSONToMap = JSON.valueForKeyPath(keyPath)
        } else {
            JSONToMap = JSON
        }
        
        return map(JSONToMap)
    }
    
    // Maps an optional NSData object to an array of objects that conform to Mappable
    internal func mapDataArray(JSONData: NSData?, keyPath: String? = nil) -> [N]? {
        guard let JSONData = JSONData else {
            return nil
        }
        
        var JSON: AnyObject?
        do {
            JSON = try NSJSONSerialization.JSONObjectWithData(JSONData, options: .AllowFragments)
        } catch {
            return nil
        }
        
        var JSONToMap: AnyObject?
        if let JSON = JSON, keyPath = keyPath where !keyPath.isEmpty {
            JSONToMap = JSON.valueForKeyPath(keyPath)
        } else {
            JSONToMap = JSON
        }

        return mapArray(JSONToMap)
    }
    
}