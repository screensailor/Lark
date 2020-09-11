import Hope
@testable import Peek

class Peek™: Hopes {
    
    func test_peek() {
        peek()
        5.peek("✅")
        peek(\.name)
        peek("✅", \.name){ print("❗️log", $0.log()) }
        2 + 3 ¶ "✅"
        2 + 3 ¶ "✅".here()
        print( "⚠️".error() )
        2 + 3 ¶ here()
    }
}


