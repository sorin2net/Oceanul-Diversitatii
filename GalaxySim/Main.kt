package galaxysim

fun main() {
    val milkyWay = Galaxy("Milky Way", 10, 5)
    println("Initial positions:")
    milkyWay.displayInfo()
    for(i in 0 until 100){
        milkyWay.simulate(1.0)
    }
    println("\nPositions after 100 time steps:")
    milkyWay.displayInfo()
}