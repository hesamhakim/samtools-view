version 1.0
task viewRegion {
    input {
		File bam_or_cram_input
		File bam_or_cram_index
		File bed
		String region
		String outputRoot
		Int mem_gb
		Int addtional_disk_size = 200 
		Int machine_mem_size = 15
		Int disk_size = ceil(size(bam_or_cram_input, "GB")) + addtional_disk_size
		}

	command {
		bash -c "echo ~{bam_or_cram_input}; samtools; samtools view ~{bam_or_cram_input} -X ~{bam_or_cram_index} ~{region} -b -o ~{outputRoot}/~{bam_or_cram_input}.extracted.bam"
	}

	output {
		File extractedBam = "~{outputRoot}/~{bam_or_cram_index}.extracted.bam"

	}

	runtime {
		docker: "quay.io/jlanej/mosdepth-docker:sha256:6c31a803fad8ed5873cbd856b057039ced23768cf260d7317c57b0f7a9663e11"
		memory: mem_gb + "GB"
		disks: "local-disk " + disk_size + " HDD"
	}

	meta {
		author: "jlanej_hesam"
	}
}

workflow extractRegionWorkflow {
	input {
	File bam_or_cram_input
	File bam_or_cram_index
	String outputRoot
	String region
	File bed
	Int mem_gb
	}
	call viewRegion { 
		input:
	 bam_or_cram_input=bam_or_cram_input,
	 bam_or_cram_index=bam_or_cram_index,
	 region=region,
	 outputRoot=outputRoot,
	 bed=bed,
	 mem_gb=mem_gb 
	}
}

#
