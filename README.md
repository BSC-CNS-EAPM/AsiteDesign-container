# AsiteDesign_container
This github contains the mount_image.sh to create the container for AsiteDesign from the Dockerfile.

AsiteDesign combines the PyRosetta modules with enhanced sampling techniques to design both the catalytic and non-catalytic residues in given active sites.

The github of AsiteDesign can be found: [Github](https://github.com/masoudk/AsiteDesign)

Disclaimer
---
PyRosetta is an interactive Python-based interface to the powerful Rosetta molecular modeling suite. It enables users to design their own custom molecular modeling algorithms using Rosetta sampling methods and energy functions.

PyRosetta was created at Johns Hopkins University by Jeffrey J. Gray, Sergey Lyskov, and the PyRosetta Team.

AsiteDesign use PyRosetta for academic purpose.

To use PyRosetta you need to obtain a [Rosetta license](https://www.pyrosetta.org/home/licensing-pyrosetta) and follow their instructions.


Creating the container
---
Pre-requisites:
- Have installed [Docker](https://docs.docker.com/engine/install/ubuntu/).
- Have installed [Singularity](https://docs.sylabs.io/guides/3.0/user-guide/installation.html).
- Have a PyRosetta license (user and password).
- Have sudo access, as docker daemon is owned by root.

To create the image:
  1. Download or clone the repository with:
  ```
  git clone https://github.com/BSC-CNS-EAPM/AsiteDesign-container.git
  ```
  2. Unzip the repository.
  3. Add executing rights to mount_image.sh.
  4. Execute mount_image.sh with PyRosetta credentials as arguments.
  ```
  ./mount_image.sh
  ```

Setup AsiteDesign
---
Files needed:
- **An input PDB file** with the complex (ligand docked to the protein, otherwise the ligand can be placed by the code, but it's better to have it already bound).
- **The parameters of all ligands**, cofactors, and non-conventional amino acids that appear in the simulation (to generate them, for instance, save the ligand as mol2 file from Pymol. Then, use for exemple the molfile_to_params Python script from Rosetta to transform to a params file).
- **An input yaml**.

The parameters that should be set in the **input yaml** file are the following:

	· PDB --> Add the name of your input PDB file
	· ParameterFiles --> Add the name of all the used params files (list them with "-")
	· Name --> Add the name of the desired output folder
	· DesignResidues --> Add the list of residues allowed to be mutated (ZZ leaves the residue as frozen. ZX stands for not mutable, but repackable. XX stands for mutable and repackable and XX+ adds the option to use the native residue as well. You can also specify to which residues you want to allow it to mutate by listing them, for instance, 100-A: AILFWVPY)
	· CatalyticResidues --> Specify the number of residues of the active site that wants to be added (RES1, RES2 ... RESN: H)
	· Ligands, 1-L (you have to specify the ligand by giving the residue number and the chain of the specific LIG). Also, the torsions that want to be excluded must be specified by the user ("ExcludedTorsions")
	· Constraints --> Add the distance and sequence constraints that you want. The distance constraints should be added by passing two residues (with residue_number-chain) and two atoms (atomname) and to which values you want to constraint them (lb: value in angstroms, hb: value in angstroms)
	· nIterations --> Number of adaptive sampling epochs that want to be performed
	· nSteps --> Number of steps performed in each epoch/iteration
	· nPoses --> Number of final poses (mutants/designs) to be reported (each one given to a processor/CPU)
	· Time --> Time in the queue (if it's run in a cluster)

Using AsiteDesign
---
To use AsiteDesign:
```
singularity exec edesign.sif python -m ActiveSiteDesign input.yaml > output.out
```
To use AsiteDesign with mpi and singularity:
```
mpirun -n CPUs singularity exec edesign.sif python -m ActiveSiteDesign input.yaml > output.out
```

AsiteDesign exemple
---
In the folder "Templatized_control_file" you will find an exemple yaml for "Directed evolution" and "Design catalytic site" with its corresponding pdb file.
