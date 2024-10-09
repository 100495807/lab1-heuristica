# Definición de conjuntos
set AVIONES;
set TARIFAS;

# Parámetros para las características de los aviones
param Asientos{AVIONES}, >= 0;
param Capacidad{AVIONES}, >= 0;

# Parámetros para las tarifas
param Precio{TARIFAS}, >= 0;
param Peso{TARIFAS}, >= 0;

# Variables de decisión (declaradas como enteras)
var x{AVIONES, TARIFAS} >= 0, integer;

# Función objetivo
maximize Beneficio_Total:
    sum{i in AVIONES, j in TARIFAS} Precio[j] * x[i,j];

# Restricciones:
# 1. No superar el número de asientos disponibles en cada avión
s.t. Restriccion_Asientos{i in AVIONES}:
    sum{j in TARIFAS} x[i,j] <= Asientos[i];

# 2. No superar la capacidad de equipaje en cada avión
s.t. Restriccion_Capacidad{i in AVIONES}:
    sum{j in TARIFAS} Peso[j] * x[i,j] <= Capacidad[i];

# 3. Deben venderse al menos 20 billetes LeisurePlus y 10 billetes BusinessPlus en cada avión
s.t. Minimo_LeisurePlus{i in AVIONES}:
    x[i, "LeisurePlus"] >= 20;

s.t. Minimo_BusinessPlus{i in AVIONES}:
    x[i, "BusinessPlus"] >= 10;

# 4. Los billetes estándar deben ser al menos el 60% de los billetes vendidos en cada avión
s.t. Proporcion_Estandar:
    sum{i in AVIONES} x[i, "Estandar"] >= 0.6 * sum{i in AVIONES, j in TARIFAS} x[i,j];

end;