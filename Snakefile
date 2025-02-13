import os


from getSciencebaseItems import get_sciencebase_data
from makeArrays import makeArrays
from makeDistanceMatrix import makeDistMatrix


out_dir = config['outDir']

subSetList = ["full"]
if len(config['subsetDict'])>0:
	subSetList.extend(config['subsetDict'].keys())
	
dataFileList = [os.path.splitext(x)[0] for x in config['itemDict'].keys()]

suffix = "_"+config['suffix'] if config['suffix']!="" else ""

rule all:
	input:
		expand("{outdir}/{dataFile}.csv",
			outdir = out_dir,
			dataFile = dataFileList,
			),
		expand("{outdir}/{dataFile}_{subSet}{thisSuffix}",
			outdir = out_dir,
			dataFile = [x for x in dataFileList if not x.startswith("distance") and not x.startswith("reach")],
			subSet = subSetList,
                        thisSuffix = suffix,
			sbFiles = config['itemDict'].keys()
			),
		expand("{outdir}/Obs_temp_flow_drb_{subSet}{thisSuffix}",
			outdir = out_dir,
			subSet = subSetList,
                        thisSuffix = suffix
			),
		expand("{outdir}/distance_matrix_drb_{subSet}{thisSuffix}.npz",
			outdir = out_dir,
			subSet = subSetList,
                        thisSuffix = suffix)
		

rule fetch_data:
	output:
		"{outdir}/{dataFile}.csv"
	run:
		get_sciencebase_data(config['itemDict'][[x for x in config['itemDict'].keys() if x.startswith(wildcards.dataFile)][0]],[x for x in config['itemDict'].keys() if x.startswith(wildcards.dataFile)][0],wildcards.outdir, output[0])

		
rule make_sntemp_arrays:
	input:
		os.path.join(out_dir,"sntemp_inputs_outputs_drb.csv")
	output:
		directory(expand("{outdir}/{dataFile}_{subSet}{thisSuffix}",
			outdir = out_dir,
			dataFile = "sntemp_inputs_outputs_drb",
                        thisSuffix = suffix,
			subSet = subSetList))
	run:
		makeArrays("sntemp_inputs_outputs_drb",input,subSetList,config['subsetDict'],config['tarFiles'],out_dir, config['segsToExclude'], suffix, config['qaDict'], config['aggDict'])
		
rule make_temp_arrays:
	input:
		os.path.join(out_dir,"temperature_observations_drb.csv")
	output:
		directory(expand("{outdir}/{dataFile}_{subSet}{thisSuffix}",
			outdir = out_dir,
			dataFile = "temperature_observations_drb",
                        thisSuffix = suffix,
			subSet = subSetList))
	run:
		makeArrays("temperature_observations_drb",input,subSetList,config['subsetDict'],config['tarFiles'],out_dir, config['segsToExclude'],suffix, config['qaDict'], config['aggDict'])
		
rule make_flow_arrays:
	input:
		os.path.join(out_dir,"flow_observations_drb.csv")
	output:
		directory(expand("{outdir}/{dataFile}_{subSet}{thisSuffix}",
			outdir = out_dir,
			dataFile = "flow_observations_drb",
			subSet = subSetList,
                        thisSuffix = suffix))
	run:
		makeArrays("flow_observations_drb",input,subSetList,config['subsetDict'],config['tarFiles'],out_dir, config['segsToExclude'],suffix, config['qaDict'], config['aggDict'])		

		
rule make_combined_arrays:
	input:
		os.path.join(out_dir,"temperature_observations_drb.csv"),
		os.path.join(out_dir,"flow_observations_drb.csv"),
	output:
		directory(expand("{outdir}/{dataFile}_{subSet}{thisSuffix}",
			outdir = out_dir,
			dataFile = "Obs_temp_flow_drb",
			subSet = subSetList,
                        thisSuffix = suffix))
	run:
		makeArrays("Obs_temp_flow_drb",input,subSetList,config['subsetDict'],config['tarFiles'],out_dir, config['segsToExclude'], suffix, config['qaDict'], config['aggDict'])
		
		
rule make_distance_matrix:
	input:
		os.path.join(out_dir,"distance_matrix_drb.csv")       
	output:
		expand("{outdir}/distance_matrix_drb_{subSet}{thisSuffix}.npz",
			outdir = out_dir,
			subSet = subSetList,
                        thisSuffix = suffix)
	run:
		makeDistMatrix(input[0],subSetList,config['subsetDict'],out_dir, config['segsToExclude'], suffix)