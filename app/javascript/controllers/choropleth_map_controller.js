import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"

export default class extends Controller {
  static values = { apiKey: String, votes: Object }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue
    this.map = new mapboxgl.Map({
      container: this.element,
      style: "mapbox://styles/mapbox/dark-v11",
      center: [10, 20],
      zoom: 1.3,
      projection: "naturalEarth"
    })
    this.map.on("load", () => this.addCountryLayer())
  }

  disconnect() { this.map?.remove() }

  addCountryLayer() {
    this.map.addSource("countries", {
      type: "vector",
      url: "mapbox://mapbox.country-boundaries-v1"
    })

    const entries = Object.entries(this.votesValue)

    let fillColor
    if (entries.length === 0) {
      fillColor = "rgba(0,0,0,0.04)"
    } else {
      const matchExpr = [
        "match",
        ["coalesce", ["get", "iso_3166_1"], ""],
        ...entries.flatMap(([code, count]) => [code, count]),
        0
      ]
      fillColor = [
        "interpolate", ["linear"], matchExpr,
        0,   "rgba(0,0,0,0.04)",
        1,   "#818cf8",
        10,  "#4f46e5",
        50,  "#312e81",
        100, "#1e1b4b"
      ]
    }

    this.map.addLayer({
      id: "countries-fill",
      type: "fill",
      source: "countries",
      "source-layer": "country_boundaries",
      paint: { "fill-color": fillColor, "fill-opacity": 0.75 }
    })

    this.map.addLayer({
      id: "countries-border",
      type: "line",
      source: "countries",
      "source-layer": "country_boundaries",
      paint: { "line-color": "rgba(255,255,255,0.1)", "line-width": 0.5 }
    })

    // One-time diagnostic — logs the actual property names available on a feature
    setTimeout(() => {
      const features = this.map.queryRenderedFeatures({ layers: ["countries-fill"] })
      if (features.length > 0) {
        console.log("[choropleth] feature props:", features[0].properties)
      } else {
        console.log("[choropleth] no features rendered yet")
      }
    }, 2000)
  }
}
