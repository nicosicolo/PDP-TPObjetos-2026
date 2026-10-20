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



object sectorFamilia inherits SectorPorMesa (cantidadDeMesas = 6, invitadosPorMesa = 4) {}

object sectorFacultad inherits SectorPorGrupo (cantidadDeGrupos = 3, invitadosPorGrupo = 4, acompaniantesPorInvitado = 2) {}

object isabella {
  var property ahorros = 10000000
  const property porcentajeMaximo = 60
  const property sectoresInvitados = [sectorFacultad, sectorFamilia]

  method cantidadDeInvitados() = sectoresInvitados.map({sector => sector.cantidadDeInvitados()}).sum()

  method precioCatering(catering) = catering.precio(self.cantidadDeInvitados())

  method puedeContratar(catering) = self.precioCatering(catering) <= self.presupuesto()

  method presupuesto() = ahorros * (100 / porcentajeMaximo)

}

/* ENTREGA 2 */

class Fiesta {
  const property sectores
  var property duracion

  method cantidadDeSectores() = sectores.size()
  method cantidadInvitados() = sectores.sum({sector => sector.cantidadDeInvitados()})
  method esComplicada() = self.cantidadDeSectores() > 3
  method esLarga() = duracion > 5
}

//  Sector como Service Class.
class Sector {
  method cantidadDeInvitados()
}

class SectorPorMesa inherits Sector {
  var property cantidadDeMesas
  var property invitadosPorMesa

  override method cantidadDeInvitados() = invitadosPorMesa * cantidadDeMesas
}

class SectorPorGrupo inherits Sector {
  const property cantidadDeGrupos
  const property invitadosPorGrupo
  const property acompaniantesPorInvitado

  override method cantidadDeInvitados() = cantidadDeGrupos * (invitadosPorGrupo + acompaniantesPorInvitado)
}

class Proveedor {
  method precioFinal(fiesta)
}

class Salon inherits Proveedor {
  var property montoFijoSector
  override method precioFinal(fiesta) = montoFijoSector * fiesta.cantidadSectores()
}

class Organizadores inherits Proveedor {
  var property montoFijoSector
  const property recargoFiestaComplicada = 0.20

  method precioFiesta (fiesta) = fiesta.cantidadDeSectores() * montoFijoSector

  method precioFiestaConRecargo (fiesta) = self.precioFiesta(fiesta) * (1 + recargoFiestaComplicada)

  override method precioFinal(fiesta) {
    if (fiesta.esComplicada()) {
      return self.precioFiestaConRecargo(fiesta)
    } else {
      return self.precioFiesta(fiesta)
    }
  }
}

class EquipoMozos inherits Proveedor {
  var property mozosPorSector
  const property precioHoraSector = 50

  override method precioFinal(fiesta) = fiesta.cantidadDeSectores() * mozosPorSector * fiesta.duracion() * precioHoraSector
}
