// src/core/logic.cj
package network_analyzer.core

import std.collection.*

// 定义返回结果的结构
public struct NetworkResult {
    public var maxNodeName: String
    public var totalWeight: Int64

    public init(name: String, weight: Int64) {
        this.maxNodeName = name
        this.totalWeight = weight
    }
}

public class NetworkAnalyzer {
    // 节点名称 -> 权重
    private var weights: HashMap<String, Int64>
    // 邻接表：节点 -> 相连的节点列表
    private var adj: HashMap<String, ArrayList<String>>

    public init() {
        weights = HashMap<String, Int64>()
        adj = HashMap<String, ArrayList<String>>()
    }

    public func addNode(name: String, weight: Int64): Unit {
        weights.add(name, weight)
        if (!adj.contains(name)) {
            adj.add(name, ArrayList<String>())
        }
    }

    public func addEdge(u: String, v: String): Unit {
        // 无向图，双向添加
        if (adj.contains(u)) {
            adj[u].add(v)
        }
        if (adj.contains(v)) {
            adj[v].add(u)
        }
    }

    // 核心计算函数
    public func solve(): NetworkResult {
        var visited = HashSet<String>()
        var globalMaxWeight: Int64 = -1
        var resultNodeName = ""

        // 遍历所有节点
        for (node in weights.keys()) {
            if (!visited.contains(node)) {
                // 发现新的连通分量
                var currentComponentWeight: Int64 = 0
                var maxNodeInComponent = ""
                var maxWeightInComponent: Int64 = -1

                // 使用栈进行 DFS
                var stack = ArrayList<String>()
                stack.add(node)
                visited.add(node)

                while (stack.size > 0) {
                    // 弹出栈顶
                    let curr = stack[stack.size - 1]
                    stack.remove((stack.size - 1)..stack.size)

                    // 获取当前节点权重
                    let w = weights.get(curr).getOrThrow()
                    currentComponentWeight += w

                    // 检查是否是该组件中最大的节点
                    if (w > maxWeightInComponent) {
                        maxWeightInComponent = w
                        maxNodeInComponent = curr
                    }

                    // 遍历邻居
                    if (adj.contains(curr)) {
                        for (neighbor in adj[curr]) {
                            if (!visited.contains(neighbor)) {
                                visited.add(neighbor)
                                stack.add(neighbor)
                            }
                        }
                    }
                }

                // 比较当前连通网络的权重与全局最大值
                if (currentComponentWeight > globalMaxWeight) {
                    globalMaxWeight = currentComponentWeight
                    resultNodeName = maxNodeInComponent
                }
            }
        }

        return NetworkResult(resultNodeName, globalMaxWeight)
    }
}
