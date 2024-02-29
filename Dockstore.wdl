version 1.0
task viewBamRegion {
    input {
		File bam_input
		File bam_index
		File bed
		String region
		String outputRoot
		Int mem_gb
		Int addtional_disk_size = 200 
		Int machine_mem_size = 15
		Int disk_size = ceil(size(bam_input, "GB")) + addtional_disk_size
		}

	command {
		bash -c "echo ~{bam_input}; samtools; samtools view ~{bam_input} -X ~{bam_index} ~{region} -b -o ~{outputRoot}/~{bam_input}.extracted.bam"
	}

	output {
		File extractedBam = "~{outputRoot}/~{bam_input}.extracted.bam"

	}

	runtime {
		docker: "quay.io/ldcabansay/samtools:latest"
		memory: mem_gb + "GB"
		disks: "local-disk " + disk_size + " HDD"
	}

	meta {
		author: "jlanej_hesam"
	}
}

workflow extractRegionWorkflow {
	input {
	File bam_input
	File bam_index
	String outputRoot
	String region
	File bed
	Int mem_gb
	}
	call viewBamRegion { 
		input:
	 bam_input=bam_input,
	 bam_index=bam_index,
	 region=region,
	 outputRoot=outputRoot,
	 bed=bed,
	 mem_gb=mem_gb 
	}
}

#
