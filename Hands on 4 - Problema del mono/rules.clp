;; R01: El mono camina a una posición diferente
(defrule mono-camina
    ?e <- (estado-juego (mono-pos ?p1) (caja-pos ?cpos) (banana-pos ?bpos) (mono-encima no) (tiene-banana no))
    (test (neq ?p1 ?cpos)) ; Asegura que no está donde está la caja (si no, podría empujar)
    (test (neq ?p1 ?bpos)) ; Asegura que no está donde está la banana
    =>
    ;; Asume que el mono camina a la posición de la caja para la siguiente acción
    (modify ?e (mono-pos ?cpos))
    (printout t crlf "*** ACCIÓN: CAMINAR ***" crlf
                "Mono se mueve de " ?p1 " a " ?cpos crlf)
)

;; R02: El mono empuja la caja
(defrule mono-empuja-caja
    ?e <- (estado-juego (mono-pos ?cpos) (caja-pos ?cpos) (banana-pos ?bpos) (mono-encima no) (tiene-banana no))
    (test (neq ?cpos ?bpos)) ; Asegura que la caja no está bajo la banana (si no, podría subirse)
    =>
    ;; Empuja la caja a la posición de la banana
    (modify ?e (caja-pos ?bpos) (mono-pos ?bpos))
    (printout t crlf "*** ACCIÓN: EMPUJAR CAJA ***" crlf
                "Mono empuja la caja de " ?cpos " a " ?bpos " (bajo la banana)" crlf)
)

;; R03: El mono se sube a la caja
(defrule mono-se-sube
    ?e <- (estado-juego (mono-pos ?bpos) (caja-pos ?bpos) (banana-pos ?bpos) (mono-encima no) (tiene-banana no))
    =>
    (modify ?e (mono-encima si))
    (printout t crlf "*** ACCIÓN: SUBIRSE A LA CAJA ***" crlf
                "Mono se sube a la caja en la posición " ?bpos crlf)
)

;; R04: El mono alcanza la banana (Paso 1: Solo la agarra)
(defrule mono-alcanza-banana
    ?e <- (estado-juego (mono-pos ?bpos) (caja-pos ?bpos) (banana-pos ?bpos) (mono-encima si) (tiene-banana no))
    (meta (tiene-banana si))
    =>
    (modify ?e (tiene-banana si))
    (assert (banana-estado (estado pelar)))
    (printout t crlf "*** ACCIÓN: ALCANZAR BANANA ***" crlf
                "Mono agarró la banana. ¡Ahora necesita pelarla!" crlf)
)

;; R05: El mono pela la banana
(defrule mono-pela-banana
    ?e <- (estado-juego (tiene-banana si))
    ?b <- (banana-estado (estado pelar))
    =>
    (modify ?b (estado pelada)) ; La banana pasa a estado 'pelada'
    (printout t crlf "*** ACCIÓN: PELAR BANANA ***" crlf
                "Mono pelando la banana. Ya casi está lista para comer." crlf)
)

;; R06: El mono come la banana
(defrule mono-come-banana
    ?e <- (estado-juego (tiene-banana si))
    ?b <- (banana-estado (estado pelada))
    =>
    (modify ?e (tiene-banana comido)) ; Marca un estado final para la banana en el mono
    (retract ?b) ; Elimina el hecho de estado de la banana
    (printout t crlf "*** ACCIÓN: COMER BANANA ***" crlf
                "¡Ñam ñam! El mono ha comido la banana. FIN DEL PROBLEMA." crlf)
    (halt) ; Detiene la ejecución del sistema
)

;; R07: Limpieza (El mono se baja si ya tiene la banana)
(defrule mono-se-baja
    ?e <- (estado-juego (mono-encima si) (tiene-banana si))
    =>
    (modify ?e (mono-encima no))
    (printout t "*** ACCIÓN: BAJARSE ***" crlf)
)
