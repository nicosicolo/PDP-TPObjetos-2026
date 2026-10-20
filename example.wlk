object pepita {
  var energy = 100

  method energy() = energy

  method fly(minutes) {
    energy = energy - minutes * 3
  }
}


object doniaRosa {
  var property proveedorBebidas = barril
  var property precioPorInvitado = 20

  method precioCatering(cantidadDeInvitados) = precioPorInvitado * cantidadDeInvitados

  method precio(cantidadDeInvitados) = self.precioCatering(cantidadDeInvitados) + proveedorBebidas.precioTotal(cantidadDeInvitados)
}

object elBodegon {
  var property limiteInvitados = 25
  var property precioBase = 900
  var property adicionalMuchosInvitados = 35

  method excedenteInvitados(cantidadInvitados) = cantidadInvitados - limiteInvitados

  method precioMuchosInvitados(cantidadInvitados) = precioBase + adicionalMuchosInvitados * self.excedenteInvitados(cantidadInvitados)


  method precio(cantidadDeInvitados) {
    if (cantidadDeInvitados > limiteInvitados) {
      return self.precioMuchosInvitados(cantidadDeInvitados)
    } else {
      return precioBase
    }
  }
}

object pizzasNico {
  var property tamanioBloque = 10
  var property precioPorBloque = 350
  var property proveedorBebidas = barril
  method cantidadDeBloques(cantidadDeInvitados) = cantidadDeInvitados.roundUp() / tamanioBloque
  method precio(cantidadDeInvitados) = self.precioCatering(cantidadDeInvitados) + proveedorBebidas.precioTotal(cantidadDeInvitados)
  method precioCatering(cantidadDeInvitados) = self.cantidadDeBloques(cantidadDeInvitados) * precioPorBloque + barril.precioTotal(cantidadDeInvitados)
}


object barril {
  var property rendimiento = 40
  var property precio = 300

  method precioTotal(cantidadInvitados) = precio * (cantidadInvitados / rendimiento).roundUp()
}

object sectorFamilia {
  const property cantidadDeMesas = 6
  const property invitadosPorMesa = 4

  method cantidadDeInvitados() = cantidadDeMesas * invitadosPorMesa
}

object sectorFacultad {
  const property cantidadDeGrupos = 3
  const property invitadosPorGrupo = 4
  const property acompañantesPorInvitado = 2

  method cantidadDeInvitados() = cantidadDeGrupos * (invitadosPorGrupo + acompañantesPorInvitado)


}

object isabella {
  var property ahorros = 10000000
  const property porcentajeMaximo = 60
  const property sectoresInvitados = [sectorFacultad, sectorFamilia]

  method cantidadDeInvitados() = sectoresInvitados.map({sector => sector.cantidadDeInvitados()}).sum()

  method precioCatering(catering) = catering.precio(self.cantidadDeInvitados())

  method puedeContratar(catering) = self.precioCatering(catering) <= self.presupuesto()

  method presupuesto() = ahorros * (100 / porcentajeMaximo)

}
