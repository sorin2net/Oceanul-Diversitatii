package galaxysim

class Planet(name: String, mass: Double, x: Double, y: Double, val radius: Double, val color: String) : SpaceObject(name, mass, x, y) {

    override fun gravitationalForce(other: SpaceObject): Double {
        val force = super.gravitationalForce(other)
        return if (other is Star) force * 1.2 else force
    }

    fun displayInfo(){
        println("Planet Name: $name, Mass: $mass, Radius: $radius, Color: $color")
    }

    override fun updatePosition(dt: Double, accelerationX: Double, accelerationY: Double) {
        super.updatePosition(dt, accelerationX, accelerationY)
    }
}