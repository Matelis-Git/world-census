// app/javascript/controllers/donut_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const canvas = this.element
    canvas.style.width   = "80px"
    canvas.style.height  = "80px"
    canvas.style.minWidth  = "80px"
    canvas.style.maxWidth  = "80px"
    canvas.style.minHeight = "80px"
    canvas.style.maxHeight = "80px"

    // On lit les données du canvas
    const values = JSON.parse(canvas.dataset.donutValues)
    const labels = JSON.parse(canvas.dataset.donutLabels)
    const colors = JSON.parse(canvas.dataset.donutColors)

    // On calcule le total de votes
    const total = values.reduce((a, b) => a + b, 0)

    // On crée un tableau d'objets {value, label, color}
    // puis on trie par votes décroissants pour avoir le gagnant en premier
    const options = values.map((v, i) => ({
      value: v,
      label: labels[i],
      color: colors[i]
    })).sort((a, b) => b.value - a.value)

    // On garde seulement le top 3
    const top3 = options.slice(0, 3)

    // Pour chaque option du top 3, on crée un dataset :
    // - arc coloré = son % de votes
    // - arc gris = le reste (100% - son %)
    // weight contrôle l'épaisseur de chaque anneau
// 3 = extérieur épais, 2 = milieu, 1 = intérieur fin
    const weights = [3, 2, 1]
    const datasets = top3.map((opt, i) => {
      // cutout différent par anneau pour les espacer visuellement
      // extérieur = 70%, milieu = 50%, intérieur = 30%
      const pct = total > 0 ? opt.value / total : 0
      return {
        data: total > 0 ? [pct * 100, 100 - pct * 100] : [1],
        backgroundColor: total > 0
          ? [opt.color, "rgba(255,255,255,0.04)"]
          : ["rgba(255,255,255,0.08)"],
        borderWidth: 0,
        // On stocke la couleur pour le texte central
        weight: weights[i],
        _color: opt.color
      }
    })

    // Le % du gagnant pour l'afficher au centre
    // Si aucun vote : on crée un dataset gris placeholder
      const finalDatasets = total > 0 ? datasets : [{
        data: [1],
        backgroundColor: ["rgba(255,255,255,0.08)"],
        borderWidth: 0,
        weight: 1
      }]

      const winnerPct   = total > 0 ? Math.round(top3[0].value / total * 100) : 0
      const winnerColor = total > 0 ? top3[0].color : "rgba(255,255,255,0.25)"

    new Chart(canvas, {
      type: "doughnut",
      data: { datasets: finalDatasets },
      options: {
        // cutout global — on va gérer l'espacement via les datasets
        cutout:"55%",
        responsive: false,
        maintainAspectRatio: true,
        plugins: {
          legend:  { display: false },
          tooltip: { enabled: false },
        },
        animation: { duration: 600 },
      },
      plugins: [{
        id: "centerText",
        afterDraw(chart) {
          const { ctx, chartArea: { top, bottom, left, right } } = chart
          const cx = (left + right) / 2
          const cy = (top + bottom) / 2
          ctx.save()
          ctx.textAlign    = "center"
          ctx.textBaseline = "middle"
          ctx.fillStyle    = winnerColor
          ctx.font         = "bold 13px sans-serif"
          ctx.fillText(winnerPct + "%", cx, cy)
          ctx.restore()
        }
      }]
    })
  }
}
