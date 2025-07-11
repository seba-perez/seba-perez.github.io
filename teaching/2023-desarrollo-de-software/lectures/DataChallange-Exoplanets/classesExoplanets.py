# primero llamamos las librerias que necesitaremos
import matplotlib.pyplot as plt

# luego construimos las clases
# la clase mas importante es para definir el objeto "exoplaneta" con sus atributos
class Exoplanet:
    def __init__(self, name, mass, radius, orbit):
        self.name = name
        self.mass = mass
        self.radius = radius
        self.orbit = orbit


    def __str__(self):
        return f"{self.name}: mass={self.mass} M_J, radius={self.radius} R_J, period={self.period} days"

# luego la clase donde se define y se lee la tabla con los datos de cada exoplaneta
class ExoplanetTable:
    def __init__(self, filename):
        self.exoplanets = []
        with open(filename, 'r') as f:
            for line in f:
                name, mass, radius, orbit, period_days = line.strip().split(",")
                self.add_exoplanet(Exoplanet(name, float(mass), float(radius), float(orbit)))

    def add_exoplanet(self, exoplanet):
        self.exoplanets.append(exoplanet)

    def get_masses(self):
        # notar la manera como recorremos la lista para obtener las masas de los exoplanetas:
        return [exoplanet.mass for exoplanet in self.exoplanets] 

    def get_radii(self): 
        return [exoplanet.radius for exoplanet in self.exoplanets]

    def get_orbits(self):
        return [exoplanet.orbit for exoplanet in self.exoplanets]

    # ahora definimos las funciones para graficar
    def plot_mass_vs_radius(self):
        fig, ax = plt.subplots()
        ax.scatter(self.get_radii(), self.get_masses())
        ax.set_xlabel("Radius (R_J)")
        ax.set_ylabel("Mass (M_earth)")
        ax.set_title("Exoplanet Mass vs Radius")
        plt.show()

    def plot_mass_vs_orbits(self):
        fig, ax = plt.subplots()
        ax.scatter(self.get_orbits(), self.get_masses())
        ax.set_xlabel("Orbital radius")
        ax.set_ylabel("Mass (M_earth)")
        ax.set_title("Exoplanet Mass vs Radius")
        ax.set_xscale('log')
        ax.set_yscale('log')
        plt.show()
