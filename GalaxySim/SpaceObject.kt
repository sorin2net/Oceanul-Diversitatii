package galaxysim

import kotlin.math.pow
import kotlin.math.sqrt

open class SpaceObject(val name: String, val mass: Double, val x: Double, val y: Double) {

    fun distanceTo(other: SpaceObject): Double {
        val dx = x - other.x
        val dy = y - other.y
        return sqrt(dx.pow(2.0) + dy.pow(2.0))
    }

    open fun gravitationalForce(other: SpaceObject): Double {
        val G = 6.67430e-11
        val dist = distanceTo(other)
        if (dist == 0.0) return 0.0 // Avoid division by zero
        return (G * mass * other.mass) / dist.pow(2.0)
    }

    open fun updatePosition(dt: Double, accelerationX: Double, accelerationY: Double) {
        val newX = x + accelerationX*dt
        val newY = y + accelerationY*dt

    }
}