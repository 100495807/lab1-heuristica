# lab1-heuristica

Primera practica de Heuristica y Optimizacion centrada en modelado matematico con GLPK/MathProg. El repositorio contiene modelos, datos y resultados para problemas de planificacion y optimizacion relacionados con vuelos.

## Objetivo

Formular problemas de decision como modelos de programacion lineal/entera, resolverlos con GLPK y analizar la calidad de las soluciones obtenidas.

## Problemas Trabajados

- Maximizacion de beneficio por venta de billetes segun avion y tarifa.
- Restricciones de asientos, capacidad de equipaje y proporcion minima de tarifas.
- Minimizacion del coste de retrasos en asignacion de aterrizajes.
- Analisis de escenarios con retrasos y cambios en parametros.

## Contenido

| Archivo | Descripcion |
| --- | --- |
| `Mathprog_caso1.mod` / `.dat` | Modelo y datos del primer caso. |
| `Mathprog_caso2.mod` / `.dat` | Modelo y datos del segundo caso. |
| `Mathprog_combinado.mod` / `.dat` | Variante combinada del problema. |
| `resultado_*.txt` | Salidas de ejecucion. |
| `analisis_resultados.txt` | Interpretacion de soluciones, restricciones y complejidad. |
| `part-1.ods`, `part-2.ods` | Material auxiliar de analisis. |

## Tecnologias

- GLPK
- MathProg / GNU MathProg
- Modelado de programacion lineal entera
- Analisis de resultados y restricciones

## Como Ejecutarlo

Ejemplo con GLPK:

```bash
glpsol -m Mathprog_caso1.mod -d Mathprog_caso1.dat -o resultado_1.txt
```

Repetir cambiando el modelo y el fichero de datos segun el caso.

## Aprendizajes

- Traducir un problema real a variables, funcion objetivo y restricciones.
- Diferenciar modelos de maximizacion y minimizacion.
- Interpretar factibilidad, optimalidad y sensibilidad ante cambios.
- Comparar herramientas de optimizacion y documentar resultados.

## Estado

Proyecto academico finalizado. Se conserva como practica de optimizacion matematica aplicada.