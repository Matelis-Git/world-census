// app/javascript/controllers/donut_controller.js
// Ce controller Stimulus initialise un donut Chart.js
// sur chaque canvas qui a data-controller="donut"
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // On récupère le canvas HTML sur lequel Stimulus est attaché
    const canvas = this.element

    // On force la taille du canvas via JavaScript
    // car Bootstrap peut écraser les attributs width/height HTML
    canvas.style.width = "80px"
    canvas.style.height = "80px"

    // On lit les données stockées dans les attributs data- du canvas
    // JSON.parse convertit le texte en tableau JavaScript
    const values        = JSON.parse(canvas.dataset.values)
    const labels        = JSON.parse(canvas.dataset.labels)
    const colors        = JSON.parse(canvas.dataset.colors)
    const countryValues = JSON.parse(canvas.dataset.countryValues)
    const countryLabels = JSON.parse(canvas.dataset.countryLabels)
    const countryColors = JSON.parse(canvas.dataset.countryColors)

    // On vérifie si des votes existent
    // some() retourne true si au moins une valeur est > 0
    const hasVotes = values.some(v => v > 0)

    // On crée le donut Chart.js
    // Chart est disponible globalement via le CDN dans application.html.erb
    new Chart(canvas, {
      type: "doughnut",
      data: {
        labels: labels,
        datasets: [
          {
            // Anneau extérieur — votes par option
            label: "Votes par option",
            data: hasVotes ? values : [1],
            backgroundColor: hasVotes ? colors : ["rgba(255,255,255,0.1)"],
            borderWidth: 0,
          },
          {
            // Anneau intérieur — votes par pays (couleurs semi-transparentes)
            label: "Votes par pays",
            data: hasVotes ? countryValues : [1],
            backgroundColor: hasVotes ? countryColors : ["rgba(255,255,255,0.1)"],
            borderWidth: 2,
            borderColor: "rgba(0,0,0,0.3)",
          },
        ],
      },
      options: {
        cutout: "60%",
        plugins: {
          legend: { display: false },
          tooltip: { enabled: hasVotes },
        },
        animation: { duration: 600 },
      },
      plugins: [{
        id: "centerText",
        afterDraw(chart) {
          const { ctx, chartArea: { top, bottom, left, right } } = chart
          const centerX = (left + right) / 2
          const centerY = (top + bottom) / 2
          const data = chart.data.datasets[0].data
          const total = data.reduce((a, b) => a + b, 0)
          const max = Math.max(...data)
          const pct = total > 0 ? Math.round(max / total * 100) : 0
          ctx.save()
          ctx.textAlign = "center"
          ctx.textBaseline = "middle"
          ctx.fillStyle = "#ffffff"
          ctx.font = "bold 13px sans-serif"
          ctx.fillText(pct + "%", centerX, centerY)
          ctx.restore()
        }
      }]
    })
  }
}
