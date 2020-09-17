class CurrentKeyPathSubjects™: Hopes {

    func test() {
        let a = Sink.Var<JSON>(nil)
        let p = CurrentKeyPathSubjects<JSON>(nil)
        
        hope(p[]) == nil

        let k: JSON.Path = ["long", "and", "winding", "road"]

        a ...= p.published[k]

        p[k] = 3
        
        hope(p[]) == ["long": ["and": ["winding": ["road": 3.0]]]]

        hope(a[]) == 3
    }
}

