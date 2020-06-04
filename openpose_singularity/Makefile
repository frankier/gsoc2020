all: Singularity.openpose.v1.60 Singularity.frankier.gsoc2020

Singularity.openpose.v1.60: singularity_template
	OPENPOSE_GIT=https://github.com/CMU-Perceptual-Computing-Lab/openpose.git \
	  OPENPOSE_BRANCH=v1.6.0 \
	  cat $< | envsubst --variables '$OPENPOSE_GIT $OPENPOSE_BRANCH' > $@

Singularity.frankier.gsoc2020: singularity_template
	OPENPOSE_GIT=https://github.com/CMU-Perceptual-Computing-Lab/openpose.git \
	  OPENPOSE_BRANCH=enable-identification \
	  cat $< | envsubst --variables '$OPENPOSE_GIT $OPENPOSE_BRANCH' > $@
