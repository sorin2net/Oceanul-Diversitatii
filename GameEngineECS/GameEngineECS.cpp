#include "GameEngineECS.h"
#include <iostream>
#include <vector>
#include <algorithm>
#include <map>

Entity::Entity(EntityId id) : id(id), isActive(true) {}

void Entity::addComponent(Component* component) {
    components[component->getType()] = component;
}

Component* Entity::getComponent(ComponentType type) {
    auto it = components.find(type);
    if (it != components.end()) {
        return it->second;
    }
    return nullptr;
}

bool Entity::removeComponent(ComponentType type) {
    return components.erase(type) > 0;
}

bool Entity::isActiveEntity() const {
    return isActive;
}

void Entity::deactivate() {
    isActive = false;
}

void Entity::activate() {
    isActive = true;
}


EntityId Entity::getId() const {
    return id;
}

bool Entity::hasComponent(ComponentType type) const {
  return components.count(type) > 0;
}


EntityManager::EntityManager() : nextEntityId(1) {}


EntityId EntityManager::createEntity() {
    EntityId id = nextEntityId++;
    entities[id] = std::make_shared<Entity>(id);
    return id;
}

void EntityManager::destroyEntity(EntityId id) {
    auto it = entities.find(id);
    if (it != entities.end()) {
      // Clean up components here if necessary, to avoid memory leaks.
        entities.erase(it);
    }
}

Entity* EntityManager::getEntity(EntityId id) {
    auto it = entities.find(id);
    if (it != entities.end()) {
        return it->second.get();
    }
    return nullptr;
}

std::vector<Entity*> EntityManager::getEntities() {
  std::vector<Entity*> entityList;
  for (const auto& pair : entities) {
    entityList.push_back(pair.second.get());
  }
  return entityList;
}


void EntityManager::update() {
    for (auto& pair : entities) {
        if (pair.second->isActiveEntity()) {
            //Potentially trigger systems here based on components.
            //Example below.  In a real system, this would be greatly expanded.

            if (pair.second->hasComponent(ComponentType::Position) &&
                pair.second->hasComponent(ComponentType::Velocity)){
                auto posComp = static_cast<PositionComponent*>(pair.second->getComponent(ComponentType::Position));
                auto velComp = static_cast<VelocityComponent*>(pair.second->getComponent(ComponentType::Velocity));
                posComp->x += velComp->x;
                posComp->y += velComp->y;
            }
        }
    }
}



PositionComponent::PositionComponent(float x, float y) : x(x), y(y) {}

ComponentType PositionComponent::getType() const { return ComponentType::Position; }

VelocityComponent::VelocityComponent(float x, float y) : x(x), y(y) {}

ComponentType VelocityComponent::getType() const { return ComponentType::Velocity; }

Renderer::Renderer(EntityManager& entityManager) : entityManager(entityManager) {}

void Renderer::render() {
    std::vector<Entity*> entities = entityManager.getEntities();
    for (Entity* entity : entities) {
        if(entity->isActiveEntity() && entity->hasComponent(ComponentType::Position)){
            PositionComponent* pos = static_cast<PositionComponent*>(entity->getComponent(ComponentType::Position));
            std::cout << "Rendering entity at: " << pos->x << ", " << pos->y << std::endl;
            //More complex rendering logic here...
            // Consider using a graphics library like OpenGL or Vulkan for real rendering.

        }
    }
}

int main() {
    EntityManager entityManager;
    Renderer renderer(entityManager);

    EntityId entity1 = entityManager.createEntity();
    EntityId entity2 = entityManager.createEntity();

    entityManager.getEntity(entity1)->addComponent(new PositionComponent(10.0f, 20.0f));
    entityManager.getEntity(entity1)->addComponent(new VelocityComponent(1.0f, 0.5f));
    entityManager.getEntity(entity2)->addComponent(new PositionComponent(30.0f, 40.0f));

    entityManager.update();
    renderer.render();

    entityManager.destroyEntity(entity1);
    entityManager.update();
    renderer.render();

    return 0;
}