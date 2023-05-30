class NaveEspacial {
	var velocidad = 0
	var direccion = 0
	
	method acelerar(cuanto) {
		velocidad = (velocidad + cuanto).min(100000)
	}
	method desacelerar(cuanto) { /* hacer */ }
	method irHaciaElSol() { direccion = 10 }
	method escaparDelSol() { direccion = -10 }
	method ponerseParaleloAlSol() { direccion = 0 }
	
	/* hacer el resto de los métodos y clases*/
}


