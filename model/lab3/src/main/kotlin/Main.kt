import kotlin.math.pow

fun main(args: Array<String>) {
    print("lambda = ")
    val lambda = readDouble()
    print("n = ")
    val n = readInt()
    print("v = ")
    val v = readDouble()

    val ro = lambda * v;

    val reject = (ro.pow(n) / n.fact()) / sumWithOperation(n) { index ->
        ro.pow(index) / index.fact()
    }

    val k = lambda * (1 - reject) * v
    val r = k / n
    println("Reject = $reject")
    println("R = $r")

}

fun sumWithOperation(n: Int, block: (Int) -> Double): Double {
    var result = 0.0;
    for (i in 0..n) {
        result += block(i)
    }
    return result
}


fun Int.fact(): Long {
    var factorial = 1L
    for (i in 1..this) {
        factorial *= i
    }
    return factorial
}

fun readInt() = readln().toInt()
fun readDouble() = readln().toDouble()