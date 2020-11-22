class DataAsSignal™: Hopes {
    
    var data: [String: Result<Data, Error>] = [:]
    
    func test() {
        
        
    }
}

extension Dictionary where Value == Result<Data, Error> {
    
    subscript<T: Codable>(
        key: Key,
        as type: T.Type = T.self,
        decoder decoder: JSONDecoder? = nil,
        encoder encoder: JSONEncoder? = nil
    ) -> Result<T, Error> {
        get {
            switch self[key] {
            case .success(let o)?:
                do {
                    return try .success((decoder ?? JSONDecoder()).decode(T.self, from: o))
                } catch {
                    return .failure(error)
                }
            case .failure(let o)?:
                return .failure(o)
            case .none:
                return .failure("Missing \(key)".error())
            }
        }
        set {
            switch newValue {
            case .success(let o):
                do {
                    self[key] = .success(try (encoder ?? JSONEncoder()).encode(o))
                } catch {
                    self[key] = .failure(error)
                }
            case .failure(let o):
                self[key] = .failure(o)
            }
        }
    }
    
    subscript<T: Codable>(
        key: Key,
        decoder decoder: JSONDecoder? = nil,
        encoder encoder: JSONEncoder? = nil
    ) -> T? {
        get {
            try? self[key, as: T.self, decoder: decoder].get()
        }
        set {
            guard let t = newValue else {
                removeValue(forKey: key)
                return
            }
            self[key, encoder: encoder] = .success(t)
        }
    }
}

