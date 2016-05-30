func ignoreInput<T>(function: () -> ()) -> T -> () {
    return { _ in function() }
}
