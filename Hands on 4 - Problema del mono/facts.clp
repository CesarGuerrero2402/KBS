(deffacts estado-inicial
    (estado-juego 
        (mono-pos A) 
        (caja-pos B) 
        (banana-pos C)
        (mono-encima no) 
        (tiene-banana no)
    )

    (meta (tiene-banana si))
)