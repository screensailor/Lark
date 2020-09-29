@testable import Lark
import Hope

private class My: URI {
    lazy var a: a = self.var()
    lazy var scene: scene = self.var()
}

extension My {
    class a: URI, My˙c {
        lazy var b: b = self.var()
        lazy var c: My.c = self.var()
    }
}

private extension My.a {
    class b: URI, My˙c {
        lazy var c: My.c = self.var()
    }
}

private extension My {
    class c: URI {}
}

private protocol My˙c {
    var c: My.c { get }
}

private let my = My("https://thousandyears.co.uk")

class URI™: Hopes {

    func test() {
        hope("\(my.a.b.c)") == "https://thousandyears.co.uk/a/b/c"
        hope(my.a.b.c().path) == "/a/b/c"
        hope(my.a as URI is My˙c) == true
        hope(my.a.b as URI is My˙c) == true
        hope(my.a.b.c as URI is My˙c) == false
    }
}

private extension My {
    class scene: URI {
        lazy var frame: frame = self.var()
    }
}

private extension My.scene {
    class frame: URI {
        lazy var size: size = self.var()
        lazy var center: center = self.var()
    }
}

private extension My.scene.frame {
    class size: URI {}
    class center: URI {}
}

extension URI™ {
    
    func test_2() {
        hope(my.scene.frame.size().path) == "/scene/frame/size"
        hope(my.scene.frame.center().path) == "/scene/frame/center"
    }
}
