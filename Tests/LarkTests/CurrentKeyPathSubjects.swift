class CurrentKeyPathSubjects™: Hopes {

    func test() {
        let a = Sink.Var<JSON>(nil)
        let p = CurrentKeyPathSubjects<JSON>(nil)

        let k: JSON.Path = ["long", "and", "winding", "road"]

        a ...= p.published[k]

        p[k] = 3

        hope(a[]) == 3
    }
}

