package galaxysim

import kotlin.random.Random

class Galaxy(val name: String, val numberOfPlanets: Int, val numberOfStars: Int) {

    val spaceObjects: MutableList<SpaceObject> = mutableListOf()

    init {
        for (i in 0 until numberOfStars) {
            val star = Star("Star${i+1}", Random.nextDouble(1e30, 1e32), Random.nextDouble(-100.0, 100.0), Random.nextDouble(-100.0, 100.0), Random.nextDouble(1e26, 1e28))
            spaceObjects.add(star)
        }
        for (i in 0 until numberOfPlanets) {
            val planet = Planet("Planet${i+1}", Random.nextDouble(1e24, 1e26), Random.nextDouble(-100.0, 100.0), Random.nextDouble(-100.0, 100.0), Random.nextDouble(1000.0, 10000.0), "random color")
            spaceObjects.add(planet)
        }
    }

    fun simulate(dt:Double){
        for(i in 0 until spaceObjects.size){
            var accelerationX = 0.0
            var accelerationY = 0.0
            for(j in 0 until spaceObjects.size){
                if (i != j){
                    val force = spaceObjects[i].gravitationalForce(spaceObjects[j])
                    val distance = spaceObjects[i].distanceTo(spaceObjects[j])
                    val directionX = (spaceObjects[j].x - spaceObjects[i].x) / distance
                    val directionY = (spaceObjects[j].y - spaceObjects[i].y) / distance
                    accelerationX += force * directionX / spaceObjects[i].mass
                    accelerationY += force * directionY / spaceObjects[i].mass

                }
            }
            spaceObjects[i].updatePosition(dt, accelerationX, accelerationY)
        }
    }

    fun displayInfo(){
        println("Galaxy Name: $name")
        spaceObjects.forEach {
            if(it is Planet) it.displayInfo()
            else if (it is Star) it.displayInfo()
        }
    }
}