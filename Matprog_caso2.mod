# Modelo de asignación de slots de aterrizaje para aviones
set AVION;  # Conjunto de aviones
set PISTA;  # Conjunto de pistas
set SLOT;   # Conjunto de slots de tiempo (horas reales)

param HoraProgramada {a in AVION};                              # Hora programada de llegada de cada avión (horas reales)
param HoraLimite {a in AVION};                                  # Hora límite de aterrizaje de cada avión (horas reales)
param HoraPosibleLlegada {s in SLOT};                           # Hora de inicio de cada slot (horas reales)
param CostePorMinuto {c in AVION}, >= 0;                        # Coste por minuto de retraso de cada avión, siempre positivo
param SlotDisponiblePorPista {p in PISTA, s in SLOT}, binary;   # Disponibilidad de los slots (1 = disponible, 0 = no disponible)
param M;                                                        # Valor muy grande, big-M

# Variables
var disponibilidad{a in AVION, p in PISTA, s in SLOT}, binary;  # Variable binaria: 1 si el avión aterriza en el slot t de la pista p

# Función objetivo: Minimizar el coste total de los retrasos
minimize TotalCost:
    sum {a in AVION, p in PISTA, s in SLOT} CostePorMinuto[a] * (HoraPosibleLlegada[s] - HoraProgramada[a]) * disponibilidad[a,p,s];

# Restricciones

# Restricción 1: Cada avión debe aterrizar exactamente una vez
s.t. OneLanding {a in AVION}:
    sum {p in PISTA, s in SLOT} disponibilidad[a,p,s] = 1;

# Restricción 2: Un slot solo puede estar asignado a un avión
s.t. OnePlanePerSlot {p in PISTA, s in SLOT}:
    sum {a in AVION} disponibilidad[a,p,s] <= 1;

# Restricción 3: Solo se pueden asignar slots disponibles
s.t. SlotAvailability {a in AVION, p in PISTA, s in SLOT}:
    disponibilidad[a,p,s] <= SlotDisponiblePorPista[p,s];

# Restricción 4: El slot debe ser igual o posterior a la hora de llegada programada
s.t. AfterArrival {a in AVION, p in PISTA, s in SLOT}:
    HoraPosibleLlegada[s] >= HoraProgramada[a] - M * (1 - disponibilidad[a,p,s]);

# Restricción 5: El slot debe ser igual o anterior a la hora límite de aterrizaje
s.t. BeforeDeadline {a in AVION, p in PISTA, s in SLOT}:
    HoraPosibleLlegada[s] <= HoraLimite[a] + M * (1 - disponibilidad[a,p,s]);

# Restricción 6: Si un avión aterriza en el slot t de la pista p, el siguiente slot t+1 no puede ser ocupado por ningún avión
s.t. NoConsecutiveSlots {a in AVION, p in PISTA, s in 1..6}:
    disponibilidad[a,p,s] + disponibilidad[a,p,s+1] <= 1;

end;