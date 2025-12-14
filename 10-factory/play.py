from z3 import Int, Solver

x = Int('x')
y = Int('y')

s = Solver()

s.add(x > 2)
s.check()
soln = s.model()

x_soln = soln[x]
import code; code.interact(local=locals())
print(type(soln[x]))
