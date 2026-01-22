from openff.toolkit import Molecule
from openmm.app import ForceField
from openmmforcefields.generators import (
    GAFFTemplateGenerator,
    SMIRNOFFTemplateGenerator,
)

molecule = Molecule.from_smiles("c1ccccc1")

for generator_class in [GAFFTemplateGenerator, SMIRNOFFTemplateGenerator]:

    template_generator = generator_class(molecules=molecule)

    forcefield = ForceField()
    forcefield.registerTemplateGenerator(template_generator.generator)

    system = forcefield.createSystem(molecule.to_topology().to_openmm())
