package network_analyzer
import network_analyzer.core.*
import std.fs.*
import std.io.*
import std.collection.*
import std.convert.*

main(args: Array<String>): Int64 {
    // 1. 检查命令行参数
    if (args.size < 1) {
        println("Error: Please provide the input file path.")
        println("Usage: cjpm run -- <file_path>")
        return 1
    }
    
    let filePath = args[0]
    
    try {
        // 2. 检查文件是否存在
        if (!exists(filePath)) {
            println("Error: File not found: ${filePath}")
            return 1
        }

        // 3. 打开并读取文件
        let file = File(filePath, OpenMode.Read)
        let bytes = readToEnd(file)
        let content = String.fromUtf8(bytes)
        file.close()

        // 4. 解析逻辑
        let lines = ArrayList<String>()
        for (line in content.split("\n")) {
            // 修复点：使用 trimAscii() 替代 trim() [6]
            let trimmed = line.trimAscii()
            if (trimmed.size > 0) {
                lines.add(trimmed)
            }
        }

        if (lines.size == 0) {
            println("Error: Empty file.")
            return 1
        }

        let analyzer = NetworkAnalyzer()
        var lineIdx = 0

        // 读取节点数 n
        if (lineIdx < lines.size) {
            let n = Int64.parse(lines[lineIdx])
            lineIdx += 1

            // 读取 n 行节点信息
            for (i in 0..n) {
                if (lineIdx >= lines.size) { break }
                let parts = lines[lineIdx].split(" ")
                lineIdx += 1
                if (parts.size >= 2) {
                    let name = parts[0]
                    let weight = Int64.parse(parts[1])
                    analyzer.addNode(name, weight)
                }
            }
        }

        // 读取连接数 m
        if (lineIdx < lines.size) {
            let m = Int64.parse(lines[lineIdx])
            lineIdx += 1
            // 读取 m 行连接信息
            for (i in 0..m) {
                if (lineIdx >= lines.size) { break }
                let parts = lines[lineIdx].split(" ")
                lineIdx += 1
                if (parts.size >= 2) {
                    analyzer.addEdge(parts[0], parts[1])
                }
            }
        }

        // 5. 计算并输出结果
        let result = analyzer.solve()
        println("${result.maxNodeName} ${result.totalWeight}")

    } catch (e: Exception) {
        println("Error processing file: ${e}")
        return 1
    }
    
    return 0
}
