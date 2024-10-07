# Modelo de asignación de slots de aterrizaje para aviones
set A;  # Conjunto de aviones
set P;  # Conjunto de pistas
set T;  # Conjunto de slots de tiempo (horas reales)

param l {A};   # Hora programada de llegada de cada avión (horas reales)
param d {A};   # Hora límite de aterrizaje de cada avión (horas reales)
param c {A};   # Coste por minuto de retraso de cada avión
param S {P, T}, binary;  # Disponibilidad de los slots (1 = disponible, 0 = no disponible)

# Variables
var x {A, P, T}, binary;  # Variable binaria: 1 si el avión aterriza en el slot t de la pista p

# Función objetivo: Minimizar el coste total de los retrasos
minimize TotalCost:
    sum {a in A, p in P, t in T} c[a] * (max(0, (t - l[a]) * 60)) * x[a,p,t];

# Restricción 1: Cada avión debe aterrizar exactamente una vez
subject to OneLanding {a in A}:
    sum {p in P, t in T} x[a,p,t] = 1;

# Restricción 2: Un slot solo puede estar asignado a un avión
subject to OnePlanePerSlot {p in P, t in T}:
    sum {a in A} x[a,p,t] <= 1;

# Restricción 3: Solo se pueden asignar slots disponibles
subject to SlotAvailability {a in A, p in P, t in T}:
    x[a,p,t] <= S[p,t];

# Restricción 4: El slot debe ser igual o posterior a la hora de llegada programada
subject to AfterArrival {a in A, p in P, t in T}:
    if t < l[a] then x[a,p,t] = 0;

# Restricción 5: El slot debe ser igual o anterior a la hora límite de aterrizaje
subject to BeforeDeadline {a in A, p in P, t in T}:
    if t > d[a] then x[a,p,t] = 0;

# Restricción 6: Si un avión aterriza en el slot t de la pista p, el siguiente slot t+1 no puede ser ocupado por ningún avión
subject to NoConsecutiveSlots {p in P, t1 in T, t2 in T: t2 = t1 + 0.15}:
    sum {a in A} x[a,p,t1] + sum {a in A} x[a,p,t2] <= 1;

end;