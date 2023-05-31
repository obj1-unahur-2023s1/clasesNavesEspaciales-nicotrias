class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	
	method acelerar(cuanto) {
		velocidad = (velocidad + cuanto).min(100000)
	}
	method desacelerar(cuanto) {
		velocidad = (velocidad - cuanto).max(0)
	}
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	method acercarseUnPocoAlSol(){ 
		direccion = (direccion + 1).min(10)
	}
	method alejarseUnPocoDelSol(){ 
		direccion = (direccion - 1).max(-10)
	}
	
	method cargarCombustible(cuanto){
		combustible += cuanto
	}
	method descargarCombustible(cuanto){
		combustible= (combustible- cuanto).max(0)
	}
	
	method prepararViaje(){
		self.prepararViajeCondicionComun()
		self.prepararViajeCondicionParticular()
	}
	
	method prepararViajeCondicionComun(){
		self.cargarCombustible(30000)
		self.acelerar(5000)		
	}
	
	method prepararViajeCondicionParticular()

	method estaTranquila()=
		self.estaTranquilaCondicionComun() and
		self.estaTranquilaCondicionParticular()
		
	method estaTranquilaCondicionComun()= // CON QUE UNO DE LOS METODOS SEA ABSTRACTO ALCANZA, ESTE HABRÍA QUE HACERLO CON super()
		combustible >= 4000 and
		velocidad <= 12000
	
	method estaTranquilaCondicionParticular()
	
	method escapar()
	method avisar()
	
	method recibirAmenaza(){	// MUCHO MUY IMPORTANTE
		self.escapar()
		self.avisar()
	}

	method estaDeRelajo()= self.estaTranquila() and 
		self.tienePocaActividad()
}

class NaveBaliza inherits NaveEspacial{
	var colorBaliza = "azul"
	var cantidadDeCambiosDeColor = 0
	
	method cambiarColorDeBaliza(colorNuevo){
		colorBaliza = colorNuevo
		cantidadDeCambiosDeColor ++
	}
	
	method colorBaliza()= colorBaliza
	
	override method prepararViajeCondicionParticular(){
		self.cambiarColorDeBaliza("verde")
		self.ponerseParaleloAlSol()	
	}
	
	override method estaTranquilaCondicionParticular()=
		colorBaliza != "rojo"

	override method escapar(){
		self.irHaciaElSol()	
	}
	
	override method avisar(){
		self.cambiarColorDeBaliza("rojo")
	}
	
	method tienePocaActividad()=
		cantidadDeCambiosDeColor == 0
}


class NaveDePasajeros inherits NaveEspacial{
	const property pasajeros 
	var racionesDeComida = 0
	var racionesDeBebida = 0
	var racionesServidas = 0
	
	method cargarComida(cantidad){
		racionesDeComida += cantidad
	}
	method cargarBebida(cantidad){
		racionesDeBebida += cantidad
	}
	
	method descargarComida(cantidad){
		racionesDeComida = 0.max((racionesDeComida - cantidad))
		racionesServidas += cantidad
	}
	method descargarBebida(cantidad){
		racionesDeBebida = 0.max((racionesDeBebida - cantidad))
	}	

	method racionesDeComida()=racionesDeComida
	method racionesDeBebida()=racionesDeBebida

	override method prepararViajeCondicionParticular(){
		self.cargarComida(4*pasajeros)
		self.cargarBebida(6*pasajeros)
		self.acercarseUnPocoAlSol()	
	}
	
	override method estaTranquilaCondicionParticular()=
		true
	
	override method escapar(){
		self.acelerar(velocidad*2)
	}
	
	override method avisar(){
		self.descargarComida(pasajeros)
		self.descargarBebida(pasajeros*2)
	}	
		
	method tienePocaActividad()=
		racionesServidas < 50
}
class NaveDeCombate inherits NaveEspacial{
	var estaInvisible = false
	var misilesDesplegados = false
	const property mensajesEmitidos = []
	
	method ponerseVisible(){
		estaInvisible = false
	}
	method ponerseInvisible(){
		estaInvisible = true
	}	
	method estaInvisible()=estaInvisible

	method desplegarMisiles(){
		misilesDesplegados = true
	}	
	method replegarMisiles(){
		misilesDesplegados = false
	}
	method misilesDesplegados()= misilesDesplegados

	method emitirMensaje(mensaje){
		mensajesEmitidos.add(mensaje)
	}
	method primerMensajeEmitido(){ 
		if(mensajesEmitidos.isEmpty()) self.error("No hay mensajes")
		return mensajesEmitidos.first()
	} 

	method ultimoMensajeEmitido(){
		if(mensajesEmitidos.isEmpty()) self.error("No hay mensajes")
		return mensajesEmitidos.last()
	}
	
	method esEscueta()= mensajesEmitidos.all({m => m.size()<=30})
	method esEscueta2()= not mensajesEmitidos.any({m => m.size()> 30})
	method emitioMensaje(mensaje)= mensajesEmitidos.contains(mensaje)

	override method prepararViajeCondicionParticular(){
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		self.emitirMensaje("Saliendo en misión")
	}
	override method estaTranquilaCondicionParticular()=
		not self.misilesDesplegados() 

	override method escapar(){
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	
	method tienePocaActividad()=
		self.esEscueta()			
}

class NaveHospital inherits NaveDePasajeros{
	var property quirofanosPreparados = false
	
	override method estaTranquilaCondicionParticular()=
		not self.quirofanosPreparados()	

	override method recibirAmenaza(){
		super()
		self.quirofanosPreparados(true)
	}
}

class NaveDeCombateSigilosa inherits NaveDeCombate{
	
	override method estaTranquilaCondicionParticular()=
		super() and not self.estaInvisible()

	override method escapar(){
		super()
		self.desplegarMisiles()		
		self.ponerseInvisible()
	}
}



