class AnyType™: Hopes {
    
    func test_decode_object() throws {
        
        struct Point: Codable, Equatable {
            let x: Double
            let y: Double
        }
        
        let type = AnyType(Point.self)
        
        let json =  try """
        { "x": 1, "y": 2 }
        """.data(using: .utf8).hopefully()
        
        let point = try type.decode(json: json)
        
        hope(point as? Point) == Point(x: 1, y: 2)
    }
    
    func test_decode_fragment() throws {
        
        let type = AnyType(Int.self)
        
        let json =  try """
        3
        """.data(using: .utf8).hopefully()
        
        let point = try type.decode(json: json)
        
        hope(point as? Int) == 3
    }
}
