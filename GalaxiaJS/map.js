class Map {
  constructor(coordinates) {
      this.coordinates = coordinates;
      this.markers = [];
  }

  addMarker(coordinate, info){
    this.markers.push({coordinate, info});
  }


  findClosestMarker(userCoordinates){
    if(this.markers.length === 0) return null;
    let closestMarker = null;
    let minDistance = Infinity;

    for(let marker of this.markers){
        let distance = this.calculateDistance(userCoordinates, marker.coordinate);
        if(distance < minDistance){
            minDistance = distance;
            closestMarker = marker;
        }
    }
    return closestMarker;
  }

  calculateDistance(coord1, coord2){
    let lat1 = coord1.latitude;
    let lon1 = coord1.longitude;
    let lat2 = coord2.latitude;
    let lon2 = coord2.longitude;

    let R = 6371; // Radius of the earth in km
    let dLat = this.deg2rad(lat2-lat1);
    let dLon = this.deg2rad(lon2-lon1);
    let a =
      Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(this.deg2rad(lat1)) * Math.cos(this.deg2rad(lat2)) *
      Math.sin(dLon/2) * Math.sin(dLon/2)
      ;
    let c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    let d = R * c; // Distance in km
    return d;
  }

  deg2rad(deg) {
    return deg * (Math.PI/180)
  }

  generateMapHTML(){
    let html = "<ul>";
    for(let marker of this.markers){
        html += `<li> Latitude: ${marker.coordinate.latitude}, Longitude: ${marker.coordinate.longitude} - Info: ${marker.info} </li>`;
    }
    html += "</ul>";
    return html;
  }
}