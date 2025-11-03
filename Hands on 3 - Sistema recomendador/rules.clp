;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Rules
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; R01: Clasificar Cliente como MAYORISTA (cantidad >= 10 en la orden)
(defrule clasificar-mayorista
  (declare (salience 10))
  ?o <- (orden (cliente-id ?cid) (qty ?q&:(>= ?q 10)))
  ?c <- (cliente (cliente-id ?cid) (nombre ?nombre) (tipo Q))
  =>
  (modify ?c (tipo mayorista))
  (printout t crlf
    "[CLASIFICACIÓN] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Cant. Total: " ?q crlf
    ">> Cliente reclasificado como MAYORISTA." crlf
    "-------------------------------------------------------------" crlf)
)

;; R02: Clasificar Cliente como MENUDISTA (cantidad < 10 en la orden)
(defrule clasificar-menudista
  (declare (salience 10))
  ?o <- (orden (cliente-id ?cid) (qty ?q&:(< ?q 10)))
  ?c <- (cliente (cliente-id ?cid) (nombre ?nombre) (tipo Q))
  =>
  (modify ?c (tipo menudista))
  (printout t crlf
    "[CLASIFICACIÓN] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Cant. Total: " ?q crlf
    ">> Cliente reclasificado como MENUDISTA." crlf
    "-------------------------------------------------------------" crlf)
)

;; =======================================================
;; PROMOCIONES POR PRODUCTO Y TARJETA
;; =======================================================

;; R03: Descuento VISA en productos Apple
(defrule promo-visa-apple
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago tarjeta) (tarjeta-grupo Visa) (tarjeta-banco ?tbanco)) ; <-- ¡AÑADIDO EL ENLACE DE VARIABLE!
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (tipo smartphone | compu) (marca Apple))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf 
    "Producto: Apple — Tarjeta: " ?tbanco " VISA" crlf ; <-- Se usa la nueva variable ?tbanco
    ">> 8% de descuento pagando con VISA en productos Apple." crlf 
    "-------------------------------------------------------------" crlf)
)

;; R04: Promoción BBVA VISA
(defrule promo-bbva-visa-cashback
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago tarjeta) (tarjeta-banco BBVA) (tarjeta-grupo Visa))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (tipo smartphone | compu))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Producto: Compra Total — Tarjeta: BBVA VISA" crlf
    ">> Promoción: 5% de cashback en esta compra pagando con BBVA VISA." crlf
    "-------------------------------------------------------------" crlf)
)

;; R05: Promoción Note25 con Liverpool VISA
(defrule promo-note25-liverpool
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago tarjeta) (tarjeta-banco Liverpool) (tarjeta-grupo Visa))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (modelo Note25) (marca Samsung))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Producto: Samsung Note25 — Tarjeta: Liverpool VISA" crlf
    ">> Oferta: 12 meses sin intereses con Liverpool VISA." crlf
    "-------------------------------------------------------------" crlf)
)

;; R06: Promoción para modelos Pro de Apple (iPhone17ProMax)
(defrule promo-iphone17promax-bancos
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago tarjeta) (tarjeta-grupo Mastercard))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (modelo iPhone17ProMax) (marca Apple))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Producto: iPhone17ProMax" crlf
    ">> Oferta Exclusiva: 18 meses sin intereses en modelos Pro con cualquier MasterCard." crlf
    "-------------------------------------------------------------" crlf)
)

;; R07: Descuento adicional para clientes MAYORISTAS
(defrule descuento-mayorista-volumen
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid))
  (cliente (cliente-id ?cid) (nombre ?nombre) (tipo mayorista))
  (detalle-orden (tipo smartphone | compu) (marca ?m) (modelo ?mod))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ") - MAYORISTA" crlf
    "Producto: " ?m " " ?mod crlf
    ">> DESCUENTO: 10% adicional por ser cliente Mayorista." crlf
    "-------------------------------------------------------------" crlf)
)

;; R08: Descuento por pago al CONTADO en Computadoras
(defrule descuento-contado-compu
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago contado))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (tipo compu) (modelo ?mod) (marca ?m))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Producto: " ?m " " ?mod crlf
    ">> DESCUENTO: 7% de descuento extra por pago al contado en Computadoras." crlf
    "-------------------------------------------------------------" crlf)
)

;; =======================================================
;; PROMOCIONES POR COMBINACIÓN DE PRODUCTOS (Combos)
;; =======================================================

;; R09: Combo MacBookAir + iPhone16 (Asume que ambos ítems están en la orden)
(defrule combo-macbookair-iphone16-vales
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago contado))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (tipo smartphone) (modelo iPhone16))
  (detalle-orden (tipo compu) (modelo MacBookAir))
  =>
  (assert (vale (vale-id (gensym)) (monto 100.00) (motivo "Combo MacBookAir/iPhone16") (cliente-id ?cid)))
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Productos: iPhone16 y MacBookAir" crlf
    ">> BENEFICIO: Vale de $100 por cada $1000 de compra (total de la orden)." crlf
    "-------------------------------------------------------------" crlf)
)

;; R10: Descuento de Accesorios al comprar Smartphone (Si el accesorio está en la misma orden)
(defrule descuento-accesorios-smartphone-en-orden
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (tipo smartphone))
  (detalle-orden (tipo accesorio) (marca ?m2))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Accesorios: " ?m2 " Funda/Mica" crlf
    ">> DESCUENTO: 15% de descuento en accesorios (Funda/Mica) por compra de Smartphone." crlf
    "-------------------------------------------------------------" crlf)
)

;; R11: Recomendación de Audífonos Premium al comprar un Note25 (Si NO tiene audífonos en la orden)
(defrule recomendacion-audifonos-note25
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (modelo Note25))
  ;; El patrón de negación debe buscar el tipo accesorio, y luego especificar cuál no debe ser
  (not (detalle-orden (tipo accesorio) (modelo audifonos))) ; <-- Corregido el doble slot 'tipo'
=>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Producto: Samsung Note25" crlf
    ">> RECOMENDACIÓN: Sugerir Audífonos Sony con 10% de descuento (accesorio 3003)." crlf
    "-------------------------------------------------------------" crlf)
)

;; R12: Vale por puntos si el cliente tiene muchos puntos
(defrule vale-por-puntos-acumulados
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid))
  ?c <- (cliente (cliente-id ?cid) (nombre ?nombre) (puntos ?p&:(> ?p 5000)))
  =>
  (assert (vale (vale-id (gensym)) (monto 500.00) (motivo "Canje Puntos Mayor a 5000") (cliente-id ?cid)))
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ") - Puntos: " ?p crlf
    ">> BENEFICIO: Se genera un vale de $500 por la alta acumulación de puntos." crlf
    "-------------------------------------------------------------" crlf)
)

;; =======================================================
;; PROMOCIONES POR NIVEL DE TARJETA Y MARCA
;; =======================================================

;; R13: Descuento Tarjeta Nivel Platino (en cualquier producto)
(defrule descuento-tarjeta-platino
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago tarjeta))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (tarjeta (propietario ?cid) (nivel Platino))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Tarjeta: Nivel Platino" crlf
    ">> DESCUENTO: 10% adicional por usar tarjeta de nivel Platino." crlf
    "-------------------------------------------------------------" crlf)
)

;; R14: Promoción para modelos económicos (ej. Honor X6B)
(defrule promo-honor-x6b-vale
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago contado))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (modelo X6B))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Producto: Honor X6B" crlf
    ">> PROMOCIÓN: 3 meses de suscripción gratis por la compra de este modelo." crlf
    "-------------------------------------------------------------" crlf)
)

;; R15: Promoción Master Card (General)
(defrule promo-mastercard-general
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago tarjeta))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (tarjeta (propietario ?cid) (grupo Mastercard) (banco ?banco))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Tarjeta: " ?banco " MasterCard" crlf
    ">> Descuento del 5% pagando con MasterCard (general)." crlf
    "-------------------------------------------------------------" crlf)
)

;; R16: Promoción en Accesorios de Alto Precio (Si están en la orden)
(defrule descuento-accesorios-caros
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (accesorio (precio ?p&:(> ?p 2000))) ; Busca el precio en el stock
  (detalle-orden (tipo accesorio) (id-producto ?aid))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Accesorio: ID" ?aid " (Precio: > $2000)" crlf
    ">> Descuento del 10% en accesorios con precio superior a $2000." crlf
    "-------------------------------------------------------------" crlf)
)

;; R17: Recomendación de cargador si compra smartphone de alta gama (CORREGIDA SINTAXIS)
(defrule recomendacion-cargador-high-end
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (modelo iPhone17ProMax | Note25))
  (not (detalle-orden (tipo accesorio) (modelo cargador))) ; <-- Corregido el doble slot 'tipo'
=>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Producto: High-End Smartphone" crlf
    ">> RECOMENDACIÓN: Sugerir cargador de carga rápida (accesorio 3004) con un 5% de descuento." crlf
    "-------------------------------------------------------------" crlf)
)

;; R18: Oferta 3x2 en accesorios de bajo costo
(defrule oferta-3x2-accesorios-baratos
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (qty ?q&:(>= ?q 3)))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (tipo accesorio) (qty ?aq&:(>= ?aq 3)))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Accesorios: Mica o Funda (Bajo Costo)" crlf
    ">> OFERTA: 3x2 en Mica o Funda (el de menor precio es gratis)." crlf
    "-------------------------------------------------------------" crlf)
)

;; R19: Descuento 5% a Menudistas en su segunda compra (Fidelidad)
(defrule descuento-menudista-fidelidad
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid))
  (cliente (cliente-id ?cid) (nombre ?nombre) (tipo menudista) (puntos ?p&:(> ?p 1000)))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ") - Menudista" crlf
    "Puntos acumulados: " ?p crlf
    ">> DESCUENTO: 5% de descuento de fidelidad para menudistas con más de 1000 puntos." crlf
    "-------------------------------------------------------------" crlf)
)

;; R20: Oferta en computadora de gama media (Dell XPS13)
(defrule oferta-dell-xps13-descuento
  ?o <- (orden (orden-id ?oid) (cliente-id ?cid) (pago tarjeta))
  (cliente (cliente-id ?cid) (nombre ?nombre))
  (detalle-orden (modelo XPS13) (marca Dell))
  =>
  (printout t crlf
    "[ORDEN: " ?oid "] Cliente: " ?nombre " (ID: " ?cid ")" crlf
    "Producto: Dell XPS13" crlf
    ">> OFERTA: 24 meses sin intereses con cualquier tarjeta." crlf
    "-------------------------------------------------------------" crlf)
)