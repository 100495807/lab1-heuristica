# Definición de conjuntos
set AVIONES;  # Conjunto de aviones
set TARIFAS;     # Conjunto de tarifas
set RUNWAY;    # Conjunto de pistas
set SLOT;      # Conjunto de slots de tiempo (horas reales)

# Parámetros para las características de los aviones
param Asientos{AVIONES}, >= 0;                                     # Número de asientos disponibles en cada avión
param Capacidad{AVIONES}, >= 0;                                         # Capacidad de equipaje en cada avión (en kg)

# Parámetros para las tarifas
param Precio{TARIFAS}, >= 0;                                               # Precio de cada tarifa
param Peso{TARIFAS}, >= 0;                                              # Peso del equipaje asociado a cada tarifa (en kg)

#variables locales
param minimo_leisure;
param minimo_business;
param porcentaje_minimo_estandar;

# Parámetros para los slots de aterrizaje
param scheduled_arrival {a in AVIONES};                                # Hora programada de llegada de cada avión (horas reales)
param landing_deadline {a in AVIONES};                                 # Hora límite de aterrizaje de cada avión (horas reales)
param delay_cost {a in AVIONES}, >= 0;                                 # Coste por minuto de retraso de cada avión, siempre positivo
param possible_arrival_time {s in SLOT};                                # Hora posible de llegada de cada slot (horas reales)
param slot_availability {r in RUNWAY, s in SLOT}, binary;               # Disponibilidad de cada slot de tiempo en cada pista
param big_M;                                                            # Valor muy grande, big-M
param b;                                                                # variable local b=1 
param c;                                                                # variable local c=6


# Variables de decisión (declaradas como enteras)
var billetes{AVIONES, TARIFAS} >= 0, integer;                                   # Número de billetes vendidos por avión y tarifa
var availability{a in AVIONES, r in RUNWAY, s in SLOT}, binary;        # Variable binaria: 1 si el avión aterriza en el slot t de la pista p

# Función objetivo
maximize Net_Profit:
    sum{i in AVIONES, j in TARIFAS} Precio[j] * billetes[i,j] - sum {a in AVIONES, r in RUNWAY, s in SLOT} delay_cost[a] * (possible_arrival_time[s] - scheduled_arrival[a]) * availability[a,r,s];

# Restricciones:
# 1. No superar el número de asientos disponibles en cada avión
s.t. Seat_Constraint{i in AVIONES}:
    sum{j in TARIFAS} billetes[i,j] <= Asientos[i];

# 2. No superar la capacidad de equipaje en cada avión
s.t. Capacity_Constraint{i in AVIONES}:
    sum{j in TARIFAS} Peso[j] * billetes[i,j] <= Capacidad[i];

# 3. Deben venderse al menos 20 billetes LeisurePlus y 10 billetes BusinessPlus en cada avión
s.t. Min_LeisurePlus{i in AVIONES}:
    billetes[i, "LeisurePlus"] >= minimo_leisure;

s.t. Min_BusinessPlus{i in AVIONES}:
    billetes[i, "BusinessPlus"] >= minimo_business;

# 4. Los billetes estándar deben ser al menos el 60% de los billetes vendidos en total
s.t. Standard_Proportion:
    sum{i in AVIONES} billetes[i, "Estandar"] >= porcentaje_minimo_estandar * sum{i in AVIONES, j in TARIFAS} billetes[i,j];

# 5. Cada avión debe aterrizar exactamente una vez
s.t. OneLanding {a in AVIONES}:
    sum {r in RUNWAY, s in SLOT} availability[a,r,s] = b;

# 6. Un slot solo puede estar asignado a un avión
s.t. OnePlanePerSlot {r in RUNWAY, s in SLOT}:
    sum {a in AVIONES} availability[a,r,s] <= b;

# 7. Solo se pueden asignar slots disponibles
s.t. SlotAvailability {a in AVIONES, r in RUNWAY, s in SLOT}:
    availability[a,r,s] <= slot_availability[r,s];

# 8. El slot debe ser igual o posterior a la hora de llegada programada
s.t. AfterArrival {a in AVIONES, r in RUNWAY, s in SLOT}:
    possible_arrival_time[s] >= scheduled_arrival[a] - big_M * (b - availability[a,r,s]);

# 9. El slot debe ser igual o anterior a la hora límite de aterrizaje
s.t. BeforeDeadline {a in AVIONES, r in RUNWAY, s in SLOT}:
    possible_arrival_time[s] <= landing_deadline[a] + big_M * (b - availability[a,r,s]);

# 10. Si un avión aterriza en el slot t de la pista p, el siguiente slot t+1 no puede ser ocupado por ningún avión
s.t. NoConsecutiveSlots {a in AVIONES, r in RUNWAY, s in b..c}:
    availability[a,r,s] + availability[a,r,s+b] <= b;

end;