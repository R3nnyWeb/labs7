import java.util.*
import kotlin.math.PI
import kotlin.math.pow
import kotlin.math.sin

fun main(args: Array<String>) {
    while (true){
        val (k, m) = readln().split(' ').map(String::toDouble)
        var x:Double = 0.0
        val step = PI/16
        while (x < PI){
            println(func(x, k, m).toString() + " ")
            x += step
        }
        println()
    }


}
fun func(x: Double, k: Double, m: Double) = (k* sin(x).pow(2.0) + m)