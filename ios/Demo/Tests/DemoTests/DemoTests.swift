import Testing
@testable import Demo

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    Demo.add(1, 2) == 3
}
