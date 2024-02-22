What's in this archive: 

88 Here we stoe files needed to replicate our classificaion of legislaitve proposal summaries used in the analysis of the paper titled ""Curb EU Enthusiasm: How Politicisation Shapes Bureaucratic Responsiveness".  


 
**Please note** that this project has only been tested on Linux so far and should run seamlessly on MacOS as well. Windows support remains to be tested.


## Installation

Prior to usage, please install an conda distribution for your operation system. Instructions can be found [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/).

Once conda is readily available in your `PATH`, go to the project folder an run: `conda env create -f environment.yml`

## Preprocessing

On Unix systems, it simply suffices to run `prepare.sh` prior to training a model which automatically runs the steps as laid out for Windows:

1. Extract `./observatory_summaries.zip` into `./data/summaries`
2. Run `python preprocess.py`
3. Run `python learn_tokenizer.json` (though a pre-trained tokenizer is provided)

## Usage

The experiments are configured using [Hydra](https://hydra.cc/) for which the respective configuration files can be found in `$PROJECT/configs`, which has the following structure:

```
├── config.yaml
├── experiment
│   └── lr.yaml
├── hparams
│   └── lr.yaml
├── __init__.py
└── model
    └── lr.yaml
```
* `defaults`: `config.yaml` specifies the global default configuration and is discouraged to be modified
* `hparams`:  stores the hyperparameters for a model (which might naturally differ by model or group of models)
* `model`:  comprises the base configuration per model (class); for instance, any

### Pipeline

Hydra calls the `_target_` function pointed to in the `experiment` configuration which denotes the pipeline for any group of classifiers.

For instance, other [scikit-learn](https://scikit-learn.org/) can be naturally ran by reconfiguring `model/lr.yaml` accordingly for a different scikit-learn classifier.

### Reproduction

Reproducing our results denotes running our provided `experiment` configurations, for instance, for the logistic regression classifier:

`python run.py experiment=lr`

You can overwrite single parameters of your experiment like so:

`python run.py experiment=lr hparams.cv.scoring="f1_weighted"`

See [Hydra](https://hydra.cc/) for more information on how to use the commandline-interface.

#### Low-level details

The fully documented scikit-learn pipeline can be found at `./src/run/classifier.py`.


