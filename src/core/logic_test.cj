// src/core/logic_test.cj
package network_analyzer.core

import std.unittest.*

@Test
class AnalyzerTest {
    @TestCase
    func testExampleData() {
        let analyzer = NetworkAnalyzer()
        
        // 模拟题目中的 Example 数据
        analyzer.addNode("node1", 10)
        analyzer.addNode("node2", 20)
        analyzer.addNode("node3", 30)
        analyzer.addNode("node4", 40)
        analyzer.addNode("node5", 50)

        analyzer.addEdge("node1", "node2")
        analyzer.addEdge("node4", "node5")

        let res = analyzer.solve()

        // 预期：{node4, node5} 权重90，最大节点 node5
        @Assert(res.totalWeight == 90)
        @Assert(res.maxNodeName == "node5")
    }

    @TestCase
    func testSingleNode() {
        let analyzer = NetworkAnalyzer()
        analyzer.addNode("A", 100)
        let res = analyzer.solve()
        @Assert(res.totalWeight == 100)
        @Assert(res.maxNodeName == "A")
    }
}
