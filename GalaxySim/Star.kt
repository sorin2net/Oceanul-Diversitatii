package galaxysim

class Star(name: String, mass: Double, x: Double, y: Double, val luminosity: Double) : SpaceObject(name, mass, x, y) {

    override fun gravitationalForce(other: SpaceObject): Double {
        return super.gravitationalForce(other) * 1.5
    }

    fun displayInfo(){
        println("Star Name: $name, Mass: $mass, Luminosity: $luminosity")
    }
}