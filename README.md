# AsiteDesign_container
This gitHub contains the mount_image.sh to create the container for AsiteDesign from the Dockerfile.

AsiteDesign repository combines the PyRosetta modules with enhanced sampling techniques to design both the catalytic and non-ctalytic residues in given active sites.

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
- Have sudo acces, as docker daemon is owned by root.

To create the image:
  1. Download or clone the repository with:
  ```
  git clone https://github.com/AlbertCS/AsiteDesign_container.git
  ```
  2. Decompress the repository.
  3. Add executing rights to mount_image.sh.
  4. Execute mount_image.sh with PyRosetta credentials as arguments.
  ```
  ./mount_image.sh -u USER -p PASSWORD
  ```

Using AsiteDesign
---
To use AsiteDesign:
```
singularity exec edisign.sif python -m ActiveSiteDesign input.yaml > output.out
```
To use AsiteDesign with mpi and singularity:
```
mpirun -n CPUs singularity exec edisign.sif python -m ActiveSiteDesign input.yaml > output.out
```
