;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Templates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deftemplate smartphone
   (slot sp-id)
   (slot marca)
   (slot modelo)
   (slot color (default unknown))
   (slot precio (type FLOAT))
   (slot stock (type INTEGER) (default 0)))

(deftemplate compu
   (slot computer-id)
   (slot marca)
   (slot modelo)
   (slot color (default unknown))
   (slot precio (type FLOAT))
   (slot stock (type INTEGER) (default 0)))

(deftemplate accesorio
   (slot accesorio-id)
   (slot tipo)         ;; funda, mica, cargador, audifonos...
   (slot marca)
   (slot precio (type FLOAT))
   (slot stock (type INTEGER) (default 0)))

(deftemplate cliente
   (slot cliente-id)
   (slot nombre)
   (slot tipo (default Q)) ;; menudista / mayorista
   (slot email)
   (slot puntos (type INTEGER) (default 0)))

(deftemplate tarjeta
   (slot tarjeta-id)
   (slot banco)
   (slot grupo) ;; visa, mastercard, american-express, etc.
   (slot nivel (default estandar)) ;; oro, plat, etc.
   (slot exp-date) ;; dd-mm-yy
   (slot propietario))

(deftemplate vale
   (slot vale-id)
   (slot monto)
   (slot motivo)
   (slot cliente-id))

(deftemplate orden
   (slot orden-id)
   (multislot items) ;; list of item facts represented as (tipo detalle...)
   (slot pago)       ;; tarjeta, contado, transferencia
   (slot tarjeta-banco) ;; if pago is tarjeta
   (slot tarjeta-grupo)
   (slot cliente-id)
   (slot total (type INTEGER) (default 0))
   (slot qty (type INTEGER) (default 1))) ;; convenience slot for single-item orders

(deftemplate detalle-orden
  (slot tipo (type SYMBOL))       ; smartphone, compu, accesorio
  (slot marca (type SYMBOL))
  (slot modelo (type SYMBOL))     ; Aplicable a smartphones/compus
  (slot id-producto)              ; sp-id, computer-id, accesorio-id
  (slot qty (type INTEGER))
)