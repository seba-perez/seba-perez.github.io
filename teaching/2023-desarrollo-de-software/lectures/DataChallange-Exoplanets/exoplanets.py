# DATA CHALLENGE EXOPLANET PLOT
from classesExoplanets import ExoplanetTable 


# MAIN
table = ExoplanetTable("exoplanets_all.txt")
# table.plot_mass_vs_radius()
table.plot_mass_vs_orbits()
