---
layout: post
title: "Unit-testing JSON object-mapping and structure with Alamofire"
tags: code
---

Solving the puzzle of unit-testing JSON object and url-response-data mapping in Swift 4 can be quite the challenging objective since there a many possible ways. I’d like to share mine with you.

The Alamofire documentation provides a default explanation on how to make HTTP GET requests against e.g. a rest-resource.

An example taken on 24.01.2019 from their readme on GitHub reads as follows:

```swift
Alamofire.request("https://httpbin.org/get").responseJSON { response in
    print("Request: \(String(describing: response.request))")   // original url request
    print("Response: \(String(describing: response.response))") // http url response
    print("Result: \(response.result)")                         // response serialization result

    if let json = response.result.value {
        print("JSON: \(json)") // serialized json response
    }
}
```

An error i frequently encounter is to map the responseJSON data directly into a Swift Object using either SwiftyJSON, Alamofire Object-Mapper or manually implemented object-mapping. As for testing wether the internal structure of the json-objects maps to the defined DTO an optional class/struct initializer is an elegant way to just dismiss malformed JSON objects.

An example implementation using SwiftyJSON:

```swift
import Foundation
import SwiftyJSON

public struct ExampleDTO {
    
    private enum Keys: String {
        case valueA = "valueA"
        case valueB = "valueB"
    }
    
    public var valueA: String = ""
    public var valueB: String = ""
 
    init?(with response: JSON){
        if let valueA = response[Keys.valueA.rawValue].string {
            self.valueA = valueA
        }
        
        if let valueB = response[Keys.valueB.rawValue].string {
            self.valueB = valueB
        }
        
        guard self.valueA != "", self.valueB != "" else {
            return nil
        }
    }
    
}
```

This is fine and solves the object-mapping of the json-objects defined with the response. But what about the response itself?

How can the structure of the response be tested (read: unit-tested) to ensure that it contains, e.g. an array of valid ExampleDTO objects, rather than just one objects?

After a nice discussion with our teams architect the following elegant solution was found:

```swift
public extension Data {

    public func parseForExampleResponse() -> [ExampleDTO]? {
        var result: [ExampleDTO]?
        var json: JSON?
        
        do {
            json = try JSON(data: self)
        }
        catch {
            return nil
        }
        guard let array = json?.array else {
            return nil
        }

        for object in array {
            if let example = ExampleDTO(with: object){
                if result == nil {
                    result = [ExampleDTO]()
                }
                result?.append(example)
            }
            else {
                print("ERROR: Found at least one malformed ExampleDTO in the list.")
                return nil
            }
        }
        return result
    }
}
```

Extending Foundation.Data is the key idea in this approach. This way, we can unit-test the extension rather than the Alamofire response itself, which we should avoid since this would mean mixing third-party software with our domain knowledge.

The network requests ends up to be pretty simple, yet can be unit-tested by

- unit-testing the `Foundation.Data` extension
- unit-testing the `ExampleDTO` struct

The final code can look like this:

```swift
let fullpath = "https://somequery"
print("Full path for query: \(fullpath)")

Alamofire.request(fullpath, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
    
    switch response.result {
    case .success:
        print("Successfully queried the server.")
    case .failure(let error):
        print(error)
        return
    }
    
    if let data = response.data {
        if let examples = data.parseForExampleResponse(){
            success(examples)
        }
        else {
            let error = "No examples have been found."
            print(error)
            return
        }
    }
}
```

## Conclusion

I just love the idea of extending Swift data class, structs and protocols. Especially extending Foundation Classes and extending your own protocols with default implementations makes me feel like i have super-powers.

Just make sure not to overdo things ;-)

Best wishes,

Florian
