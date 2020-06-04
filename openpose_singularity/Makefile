all: Singularity.openpose_v1.60 Singularity.frankier_gsoc2020

clean:
	rm Singularity.openpose_v1.60 Singularity.frankier_gsoc2020

Singularity.openpose_v1.60: singularity_template
	OPENPOSE_GIT=https://github.com/CMU-Perceptual-Computing-Lab/openpose.git \
	  OPENPOSE_BRANCH=v1.6.0 \
	  cat $< | envsubst '$$OPENPOSE_GIT $$OPENPOSE_BRANCH' > $@

Singularity.frankier_gsoc2020: singularity_template
	OPENPOSE_GIT=https://github.com/frankier/openpose.git \
	  OPENPOSE_BRANCH=enable-identification \
	  cat $< | envsubst '$$OPENPOSE_GIT $$OPENPOSE_BRANCH' > $@
