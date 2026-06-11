// app/javascript/controllers/census_ai_controller.js
// Controller Stimulus pour la page Census AI
// Gère : globe D3, particules canvas, états idle/thinking/speaking

import { Controller } from "@hotwired/stimulus"
import { animate, stagger, createTimer } from "animejs"

export default class extends Controller {

  // Cibles Stimulus — éléments du DOM qu'on va manipuler
  static targets = [
    "globe",      // conteneur du globe D3
    "canvas",     // canvas des particules
    "sdot",       // point de statut
    "slabel",     // texte de statut
    "rimCircle",  // cercle SVG rim glow
    "atmoCircle", // cercle SVG atmosphère
    "glowCircle"  // cercle SVG glow extérieur
  ]

  // Valeurs passées depuis le HTML via data attributes
  static values = { state: String }

  connect() {
    // connect() est appelé automatiquement par Stimulus
    // quand l'élément avec data-controller="census-ai" apparaît dans le DOM
    this.appState   = 'idle'
    this.pulseStrength  = 0
    this.targetPulse    = 0
    this.animTime       = 0
    this.particles      = []
    this.respIdx        = 0

    this._initParticles()
    this._initGlobe()
    this._startParticleLoop()

    // Demo auto — la sphère parle au chargement
    setTimeout(() => {
      this.setState('speaking')
      setTimeout(() => this.setState('idle'), 4000)
    }, 1000)
  }

  disconnect() {
    // Nettoyage quand on quitte la page — évite les memory leaks
    this._rotating = false
    if (this._rafId) cancelAnimationFrame(this._rafId)
  }

  // ── Particules ──────────────────────────────────────────

  _initParticles() {
    // Crée 80 particules orbitales autour du globe
    const canvas = this.canvasTarget
    this.CX = canvas.width / 2
    this.CY = canvas.height / 2

    for (let i = 0; i < 80; i++) {
      const angle = Math.random() * Math.PI * 2
      const dist  = 115 + Math.random() * 35
      this.particles.push({
        angle,
        dist,
        baseDist: dist,
        size:    Math.random() * 2.2 + 0.5,
        opacity: Math.random() * 0.5 + 0.1,
        // speed : chaque particule tourne à sa propre vitesse
        speed:   (Math.random() - 0.5) * 0.004 + 0.002,
        phase:   Math.random() * Math.PI * 2,
        // alternance violet clair / violet foncé
        color:   Math.random() > 0.5 ? [155, 89, 255] : [192, 132, 252]
      })
    }
  }

  _startParticleLoop() {
    const canvas = this.canvasTarget
    const ctx    = canvas.getContext('2d')

    const loop = () => {
      ctx.clearRect(0, 0, canvas.width, canvas.height)
      this.animTime += 0.012

      // Interpolation douce vers la cible
      this.pulseStrength += (this.targetPulse - this.pulseStrength) * 0.05

      this.particles.forEach(p => {
        // Vitesse de rotation selon l'état
        const speedMult = this.appState === 'speaking' ? 2.2
                        : this.appState === 'thinking' ? 1.4 : 1
        p.angle += p.speed * speedMult

        // Amplitude de pulsation selon l'état
        const pulse = this.appState === 'speaking'
          ? Math.sin(this.animTime * 4 + p.phase) * 12 * this.pulseStrength
          : this.appState === 'thinking'
          ? Math.sin(this.animTime * 7 + p.phase) * 6 * this.pulseStrength
          : Math.sin(this.animTime * 1.2 + p.phase) * 2

        const d = p.baseDist + pulse
        const x = this.CX + Math.cos(p.angle) * d
        const y = this.CY + Math.sin(p.angle) * d

        // Opacité selon l'état
        const alpha = this.appState === 'speaking'
          ? 0.3 + Math.abs(Math.sin(this.animTime * 3 + p.phase)) * 0.6
          : this.appState === 'thinking'
          ? 0.2 + Math.abs(Math.sin(this.animTime * 5 + p.phase)) * 0.5
          : p.opacity

        ctx.beginPath()
        ctx.arc(x, y, p.size, 0, Math.PI * 2)
        ctx.fillStyle = `rgba(${p.color[0]},${p.color[1]},${p.color[2]},${Math.min(1, alpha)})`
        ctx.fill()
      })

      this._rafId = requestAnimationFrame(loop)
    }

    loop()
  }

  // ── Globe D3 ────────────────────────────────────────────

  _initGlobe() {
    // D3 et TopoJSON sont chargés via CDN dans la vue ERB
    // On attend qu'ils soient disponibles
    if (typeof d3 === 'undefined' || typeof topojson === 'undefined') {
      setTimeout(() => this._initGlobe(), 100)
      return
    }

    const wrap = this.globeTarget
    const W = 280, H = 280
    this.R = 118

    const svg  = d3.select(wrap).select('svg').attr('width', W).attr('height', H)
    const defs = svg.append('defs')

    this.proj = d3.geoOrthographic()
      .scale(this.R).translate([W/2, H/2])
      .clipAngle(90).rotate([0, -20])

    this.gpath = d3.geoPath().projection(this.proj)
    const grat = d3.geoGraticule()()

    // Clip circle
    defs.append('clipPath').attr('id', 'cai-clip')
      .append('circle').attr('cx', W/2).attr('cy', H/2).attr('r', this.R)

    // Océan violet sombre
    const og = defs.append('radialGradient').attr('id','cai-og').attr('cx','38%').attr('cy','33%')
    og.append('stop').attr('offset','0%').attr('stop-color','#1a0533')
    og.append('stop').attr('offset','100%').attr('stop-color','#0a0120')
    svg.append('circle').attr('cx',W/2).attr('cy',H/2).attr('r',this.R).attr('fill','url(#cai-og)')

    // Graticules violet subtil
    this._gratPath = svg.append('path').datum(grat)
      .attr('stroke','rgba(155,89,255,0.12)').attr('stroke-width','0.5')
      .attr('fill','none').attr('clip-path','url(#cai-clip)')

    // Pays
    this._countryGroup = svg.append('g').attr('clip-path','url(#cai-clip)')

    // Borders
    this._borderPath = svg.append('path')
      .attr('fill','none')
      .attr('stroke','rgba(155,89,255,0.35)')
      .attr('stroke-width','0.6')
      .attr('clip-path','url(#cai-clip)')

    // Specular highlight
    const sg = defs.append('radialGradient').attr('id','cai-sg').attr('cx','32%').attr('cy','26%')
    sg.append('stop').attr('offset','0%').attr('stop-color','rgba(192,132,252,0.2)')
    sg.append('stop').attr('offset','55%').attr('stop-color','rgba(192,132,252,0)')
    svg.append('circle').attr('cx',W/2).attr('cy',H/2).attr('r',this.R)
      .attr('fill','url(#cai-sg)').attr('pointer-events','none')

    // Atmosphère
    const ag = defs.append('radialGradient').attr('id','cai-ag').attr('cx','50%').attr('cy','50%')
    ag.append('stop').attr('offset','82%').attr('stop-color','rgba(155,89,255,0)')
    ag.append('stop').attr('offset','100%').attr('stop-color','rgba(155,89,255,0.3)')
    this._atmo = svg.append('circle').attr('cx',W/2).attr('cy',H/2).attr('r',this.R+8)
      .attr('fill','url(#cai-ag)').attr('pointer-events','none')

    // Rim glow violet
    this._rim = svg.append('circle').attr('cx',W/2).attr('cy',H/2).attr('r',this.R)
      .attr('fill','none').attr('stroke','rgba(155,89,255,0.5)').attr('stroke-width','2')
      .attr('pointer-events','none')

    // Glow extérieur très subtil
    this._glow = svg.append('circle').attr('cx',W/2).attr('cy',H/2).attr('r',this.R+16)
      .attr('fill','none').attr('stroke','rgba(155,89,255,0.08)').attr('stroke-width','12')
      .attr('pointer-events','none')

    // Chargement TopoJSON
    d3.json('https://cdn.jsdelivr.net/npm/world-atlas@2/countries-110m.json')
      .then(world => {
        const countries = topojson.feature(world, world.objects.countries)
        this._borders = topojson.mesh(world, world.objects.countries, (a, b) => a !== b)

        this._countryGroup.selectAll('path')
          .data(countries.features).join('path')
          .attr('d', d => this.gpath(d))
          .attr('fill', 'rgba(155,89,255,0.22)')

        this._borderPath.datum(this._borders).attr('d', this.gpath)
        this._gratPath.attr('d', this.gpath(grat))
        this._startRotation(grat)
        this._initDrag(wrap)
      })
  }

  _redraw(grat) {
    this._countryGroup.selectAll('path').attr('d', d => this.gpath(d))
    if (this._borders) this._borderPath.datum(this._borders).attr('d', this.gpath)
    if (this._gratPath) this._gratPath.attr('d', this.gpath(grat))

    // Pulsation du rim selon l'état
    if (this.appState === 'speaking') {
      const p = 0.5 + Math.sin(this.animTime * 5) * 0.25
      this._rim.attr('stroke', `rgba(192,132,252,${p})`).attr('stroke-width', 2 + Math.sin(this.animTime * 5))
      this._atmo.attr('r', this.R + 8 + Math.sin(this.animTime * 4) * 4)
      this._glow.attr('stroke', `rgba(155,89,255,${0.1 + Math.sin(this.animTime * 4) * 0.06})`)
    } else if (this.appState === 'thinking') {
      const p = 0.4 + Math.sin(this.animTime * 9) * 0.2
      this._rim.attr('stroke', `rgba(167,139,250,${p})`).attr('stroke-width', '1.5')
    } else {
      this._rim.attr('stroke', 'rgba(155,89,255,0.5)').attr('stroke-width', '2')
      this._atmo.attr('r', this.R + 8)
      this._glow.attr('stroke', 'rgba(155,89,255,0.08)')
    }
  }

  _startRotation(grat) {
    this._rotating = true
    let lastT = 0

    const loop = (t) => {
      if (!this._rotating) return
      if (lastT) {
        const dt    = t - lastT
        const r     = this.proj.rotate()
        const speed = this.appState === 'speaking' ? 0.01
                    : this.appState === 'thinking'  ? 0.007 : 0.005
        this.proj.rotate([r[0] + dt * speed, r[1], r[2]])
        this._redraw(grat)
      }
      lastT = t
      requestAnimationFrame(loop)
    }
    requestAnimationFrame(loop)
  }

  _initDrag(wrap) {
    let ds = null, rs = null
    d3.select(wrap).call(
      d3.drag()
        .on('start', (e) => {
          this._rotating = false
          ds = [e.x, e.y]
          rs = this.proj.rotate()
        })
        .on('drag', (e) => {
          this.proj.rotate([
            rs[0] + (e.x - ds[0]) * 0.4,
            rs[1] - (e.y - ds[1]) * 0.4,
            rs[2]
          ])
          this._redraw(d3.geoGraticule()())
        })
        .on('end', () => { this._rotating = true })
    )
  }

  // ── États ───────────────────────────────────────────────

  setState(state) {
    this.appState = state

    if (state === 'idle') {
      this.sdotTarget.style.background   = '#7c3aed'
      this.sdotTarget.style.boxShadow    = '0 0 8px rgba(124,58,237,0.9)'
      this.slabelTarget.textContent      = 'Ready — ask me anything'
      this.targetPulse = 0

    } else if (state === 'thinking') {
      this.sdotTarget.style.background   = '#a78bfa'
      this.sdotTarget.style.boxShadow    = '0 0 12px rgba(167,139,250,1)'
      this.slabelTarget.textContent      = 'Census AI is thinking...'
      this.targetPulse = 0.6

    } else if (state === 'speaking') {
      this.sdotTarget.style.background   = '#c4b5fd'
      this.sdotTarget.style.boxShadow    = '0 0 16px rgba(196,181,253,1)'
      this.slabelTarget.textContent      = 'Census AI is speaking...'
      this.targetPulse = 1
    }
  }

  // ── Actions Stimulus (appelées depuis la vue) ───────────

  // Appelé quand l'user tape dans l'input
  typing(event) {
    if (event.target.value.length > 0 && this.appState === 'idle') {
      this.targetPulse = 0.15
    } else if (event.target.value.length === 0 && this.appState === 'idle') {
      this.targetPulse = 0
    }
  }

  // Appelé quand l'user envoie un message
  send(event) {
    event.preventDefault()
    const input = this.element.querySelector('[data-census-ai-target="input"]')
    if (!input?.value.trim()) return
    // Le form Rails gère l'envoi — on change juste l'état
    this.setState('thinking')
  }

  // Appelé par Turbo Stream quand la réponse arrive
  receiveResponse() {
    this.setState('speaking')
    setTimeout(() => this.setState('idle'), 5000)
  }
}
