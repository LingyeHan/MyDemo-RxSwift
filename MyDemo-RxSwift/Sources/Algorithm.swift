//
//  Algorithm.swift
//  MyDemo-RxSwift
//
//  Created by Lingye Han on 2020/4/24.
//  Copyright © 2020 Hanly. All rights reserved.
//

import Foundation

class Algorithm {

}

/// 一个数组中只有三个元素(如0,1,2)，要求对这样的数组进行排序，时间复杂度要求只能进行一次遍历，即 O(n)
/**
 要充分利用题给的条件：只含有0或1或2
 可以这样想：0应该往前扔，1应该不变，2应该往后扔。
 定义三个变量begin指向首下标，end指向尾下标，current最开始指向首下标。
 当current对应数组值是0的时候，跟begin去交换，然后begin++，current++，这样能保证0往前调。
 当current对应数组值是1的时候，current++
 当current对应数组值2的时候，应该与end与交换，因为2在数组中的位置是靠后的，此外，current++，end–
 */
extension Algorithm {
    
    private func swap(array: inout [Int], a: Int, b: Int) {
        let temp = array[a]
        array[a] = array[b]
        array[b] = temp
    }
    
    func sort(array: [Int]) -> [Int] {
        var l = 0, r = array.count - 1, m = 0 // 表示含有0,1,2的各自的数量
        var array = array
        // 最左边是0，从前往后找0
        while m <= r {
            if array[m] == 0 {
                swap(array: &array, a: l, b: m)
                l += 1
                m += 1
            } else if array[m] == 1 { // ==1 无需交换
                m += 1
            } else {
                swap(array: &array, a: m, b: r)
                r -= 1
            }
        }
        
        return array
    }
}

/// 青蛙跳台阶算法(斐波拉契数列)
/**
 问题描述：一只青蛙一次可以跳上1级台阶，也可以跳上2级。求该青蛙跳上一个n级的台阶总共需要多少种跳法。

 思路：首先考虑n等于0、1、2时的特殊情况，f(0) = 0  f(1) = 1  f(2) = 2 其次，当n=3时，青蛙的第一跳有两种情况：跳1级台阶或者跳两级台阶，假如跳一级，那么 剩下的两级台阶就是f(2)；假如跳两级，那么剩下的一级台阶就是f(1)，因此f(3)=f(2)+f(1)  当n = 4时，f(4) = f(3) +f(2),以此类推...........可以联想到Fibonacci数列。 因此，可以考虑用递归实现。但是递归算法效率低下，也可考虑迭代实现。
 */
extension Algorithm {
    
    // 递归算法（之前的两数相加）n>40 很慢
    func fibonacci(_ n: Int) -> Int {
        switch n {
        case 0, 1, 2:
            return n
        default:
            return fibonacci(n - 1) + fibonacci(n - 2)
        }
    }
    
    // 迭代算法     快
    func iterator(_ n: Int) -> Int {
        var former1 = 1, former2 = 2, result = 0
        switch n {
        case 0, 1, 2:
            return n
        default:
            var i = 3
            while i <= n {
                result = former1 + former2
                former1 = former2
                former2 = result
                i += 1
            }
            return result
        }
    }
/*
    递归与迭代的效率比较    我们知道，递归调用实际上是函数自己在调用自己，而函数的调用开销是很大的，系统要为每次函数调用分配存储空间，并将调用点压栈予以记录。而在函数调用结束后，还要释放空间，弹栈恢复断点。所以说，函数调用不仅浪费空间，还浪费时间。 这样，我们发现，同一个问题，如果递归解决方案的复杂度不明显优于其它解决方案的话，那么使用递归是不划算的。因为它的很多时间浪费在对函数调用的处理上。在C++中引入了内联函数的概念，其实就是为了避免简单函数内部语句的执行时间小于函数调用的时间而造成效率降低的情况出现。在这里也是一个道理，如果过多的时间用于了函数调用的处理，那么效率显然高不起来。
    虽然有这样的缺点，但是递归的力量仍然是巨大而不可忽视的，因为有些问题使用迭代算法是很难甚至无法解决的（比如汉诺塔问题）。这时递归的作用就显示出来了。
 */
    // 递归(汉诺塔) f(k+1)=2*f(k)+1, 即f(n)=2^n-1  假设64个需要，每秒钟移动一次，共需5845.54亿年才能移完
    func hanioTowers(total: Int, a: Character, b: Character, c: Character) {
        if total == 1 { //边界条件
            print("\(total) 号盘: from \(a) to \(c)")
        } else {
            hanioTowers(total: total-1, a: a, b: c, c: b)
            print("\(total) 号盘: from \(a) to \(c)")
            hanioTowers(total: total-1, a: b, b: a, c: c)
        }
    }
    
    /*
     （二分法查找）递归和非递归效率比较：
     递归算法写起来简单，但是有两个不足，一个是调用接口的开销，函数调用本身是有开销的。
     另一个是堆栈内存比较小，递归调用层次深，容易引起堆栈溢出错误（著名的stack overflow）。
     */
}

/// 反转二叉树（或二叉树的镜像）
class TreeNode {

    var value: Int
    var left: TreeNode?
    var right: TreeNode?

    init(value: Int) {
        self.value = value
    }
}
class InvertBinaryTree {
    
    private let array = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
//    private static var nodeList: [TreeNode] =
    
    // 层次(栈或列表)遍历实现 DFS(深度优先搜索法) 迭代：可以采用先序，后序的迭代版本，或者采用层序遍历也可
    func depthFirstSearch() {
        
    }
    
    // 递归实现  类似与先序和后序遍历
}
