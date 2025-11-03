;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Facts
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(deffacts inventario-productos
  (smartphone (sp-id 1900) (marca Samsung) (modelo GalaxyA22) (color Azul) (precio 8000.00) (stock 120))
  (smartphone (sp-id 1901) (marca Samsung) (modelo Note25) (color Negro) (precio 25000.00) (stock 50))
  (smartphone (sp-id 1902) (marca Apple) (modelo iPhone17ProMax) (color Naranja) (precio 50000.00) (stock 30))
  (smartphone (sp-id 1903) (marca Xiaomi) (modelo PocoX6Pro) (color Purpura) (precio 5000.00) (stock 200))
  (smartphone (sp-id 1904) (marca Samsung) (modelo GalaxyA25) (color Azul) (precio 8500.00) (stock 150))
  (smartphone (sp-id 1905) (marca Honor) (modelo X6B) (color Blanco) (precio 2500.00) (stock 250))
  (smartphone (sp-id 1906) (marca Apple) (modelo iPhone16) (color rojo) (precio 27000.00) (stock 100))

  (compu (computer-id 2001) (marca Apple) (modelo MacBookPro) (color Gris) (precio 47000.00) (stock 40))
  (compu (computer-id 2002) (marca Apple) (modelo MacBookAir) (color Plata) (precio 35000.00) (stock 60))
  (compu (computer-id 2003) (marca Dell) (modelo XPS13) (color Negro) (precio 32000.00) (stock 50))

  (accesorio (accesorio-id 3001) (tipo funda) (marca Apple) (precio 700.00) (stock 300))
  (accesorio (accesorio-id 3002) (tipo mica) (marca Generica) (precio 350.00) (stock 500))
  (accesorio (accesorio-id 3003) (tipo audifonos) (marca Sony) (precio 3000.00) (stock 80))
  (accesorio (accesorio-id 3004) (tipo cargador) (marca Samsung) (precio 500.00) (stock 120))
)

(deffacts clientes-y-tarjetas

  (cliente (cliente-id 1001) (nombre "Laura Gomez") (tipo menudista) (email "laura@ejemplo.com") (puntos 500))
  (cliente (cliente-id 1002) (nombre "Distribuidora Tech") (tipo mayorista) (email "tech@dist.com") (puntos 15000))
  (cliente (cliente-id 1003) (nombre "Carlos Ruiz") (tipo menudista) (email "carlos@ejemplo.com") (puntos 1200))


  (tarjeta (tarjeta-id 5001) (banco Banamex) (grupo Visa) (nivel Oro) (exp-date "01-12-25") (propietario 1001))
  (tarjeta (tarjeta-id 5002) (banco BBVA) (grupo Mastercard) (nivel Platino) (exp-date "06-08-26") (propietario 1002))
  (tarjeta (tarjeta-id 5003) (banco Liverpool) (grupo Visa) (nivel Estandar) (exp-date "03-05-24") (propietario 1003))


  (vale (vale-id 6001) (monto 250.00) (motivo "Reembolso") (cliente-id 1001))
)