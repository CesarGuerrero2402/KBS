;; Define el estado actual del juego
(deftemplate estado-juego
    (slot mono-pos)     ;; Posición del mono (A, B, C, D o E)
    (slot caja-pos)     ;; Posición de la caja (A, B, C, D o E)
    (slot banana-pos)   ;; Posición de la banana (en la misma pos que la caja)
    (slot mono-encima (default no)) ;; ¿Está el mono subido a la caja? (si/no)
    (slot tiene-banana (default no)) ;; ¿Tiene el mono la banana? (si/no)
)

;; Define la meta a alcanzar
(deftemplate meta
    (slot tiene-banana)
)

;; Nuevo Template a añadir en mono-templates.clp
(deftemplate banana-estado
    (slot estado) ;; pelar, pelada, comida
)