Simple Simulations
==================

This page describes two examples of Etomica simulations, Monte Carlo and molecular dynamics.  Almost all simulations include several basic components: a Box, a Species, an Integrator and a PotentialMaster containing a Potential.


Monte Carlo
~~~~~~~~~~~

The class ``etomica.simulations.prototypes.LJMC3D`` provides a good example of a Monte Carlo simulation.  You can view the `LJMC3D code <https://github.com/etomica/etomica/blob/master/etomica-core/src/main/java/etomica/simulation/prototypes/LJMC3D.java>`_ directly on github.

Constructor
-----------

The primary constructor takes a ``SimParams`` (discussed in `Simulation Parameters`_) object that contains the parameters needed to specify the simulation::

  public LJMC3D(SimParams params) {

Next, we need to specify that our simulation is 3-dimensional.  We do this by invoking our super constructor (in Simulation) and passing a Space3D::

  super(Space3D.getInstance());

Now we need to make a PotentialMaster that keeps track of the potentials in our simulation and which atoms they apply to.  We'll use a PotentialMasterCell (which uses cell lists to find interacting pairs of atoms) with a cutoff of 3::

  double rc = 3;
  potentialMaster = new PotentialMasterCell(this, rc, space);

Next we need a Species, which defines the molecules (how many atoms of each type, nominal geometry).  Our system has simple atomic molecles.  Having created the species, we need to add it to ourselves (the Simulation) so that other components will know about it::

  SpeciesSpheresMono species = new SpeciesSpheresMono(this, space);
  addSpecies(species);

Now we need a Box, which contains our molecules and a Boundary, which defines the volume they can occupy and what happens at the edges.  Having created the box, we need to add it to ourselves (the Simulation) and tell it how many molecules we actually want.  Finally we need to set the box size to achieve our desired density.  The BoxInflate class provides a convenient way to do this::

  Box box = new Box(space);
  addBox(box);
  box.setNMolecules(species, params.numAtoms);
  BoxInflate inflater = new BoxInflate(box, space, params.density);
  inflater.actionPerformed();

We need to initialize the positions of the atoms in our Box.  They are initially all placed at the origin, but that is inappropriate (the energy is infinite!), so we need to initalize them.  We'll just put them on an FCC lattice.  While it may not be possible to put our atoms on a perfect lattice without vacancies, we don't really care::

  ConfigurationLattice config = new ConfigurationLattice(new LatticeCubicFcc(space), space);
  config.initializeCoordinates(box);

Now we need to set up the potential in our system.  We want a Lennard-Jones potential (P2LennardJones), but we also need truncation.  We'll use a P2SoftSphericalTruncated for that.  Having created the potential, we need to tell our PotentialMasterCell about it.  Our potential is atomic, and so we tell the ``potentialMaster`` that any two atoms of type ``atomType`` (the type of our atoms) interacts with the truncated potential::

  P2LennardJones p2lj = new P2LennardJones(space);
  P2SoftSphericalTruncated p2 = new P2SoftSphericalTruncated(space, p2lj, rc);
  AtomType type1 = species.getLeafType();
  potentialMaster.addPotential(p2, new AtomType[]{type1, type1});

Now we'll create our integrator, responsible for actually moving atoms around.  We'll use an IntegratorMC, which needs the temperature to know which moves to accept.  Finally, the integrator needs to know that it should be moving the atoms in the box we created previously::

  integrator = new IntegratorMC(this, potentialMaster);
  integrator.setTemperature(params.temperature);
  integrator.setBox(box);

The integrator knows how to move atoms around, but it doesn't know how many steps to perform.  We'll need an ActivityIntegrator to drive the integrator and stop when we want it to.  We hand the ActivityIntegrate off to a Controller, which manages the simulation when running graphically::

  activityIntegrate = new ActivityIntegrate(integrator);
  getController().addAction(activityIntegrate);

Finally, we need to finish setting up our ``potentialMaster``.  We need to tell it how many cells to look in for neighbors (how many shells) and the reset it (so that actually assigns atoms to cells).  Then, we need ensure the atom's cell assignment gets updated whenever an MC move moves an atom by registering a listener with the integrator's EventManager for moves::

  potentialMaster.setCellRange(2);
  potentialMaster.reset();
  integrator.getMoveEventManager().addListener(
                   potentialMaster.getNbrCellManager(box).makeMCMoveListener());

Molecular Dynamics
~~~~~~~~~~~~~~~~~~


Simulation Parameters
~~~~~~~~~~~~~~~~~~~~~
