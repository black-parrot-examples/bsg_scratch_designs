THIS_DIR :=$(realpath $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST)))))

GIT_CLONE_STYLE :=ssh
#GIT_CLONE_STYLE :=https

ifeq ($(GIT_CLONE_STYLE),ssh)
  GITHUB    :=git@github.com:
  BITBUCKET :=git@bitbucket.com:

else ifeq ($(GIT_CLONE_STYLE),https)
  GITHUB    :=https://github.com/
  BITBUCKET :=https://bitbucket.com/

endif

basejump_stl_dir     :=$(THIS_DIR)/basejump_stl
basejump_stl_url     :=$(GITHUB)bespoke-silicon-group/basejump_stl
basejump_stl_commit  :=master

hardfloat_dir        :=$(THIS_DIR)/HardFloat
hardfloat_url        :=$(GITHUB)bsg-external/HardFloat
hardfloat_commit     :=master

bsg_45_dir           :=$(THIS_DIR)/bsg_45
bsg_45_url           :=$(GITHUB)stdavids/bsg_45
bsg_45_commit        :=master

bsg_fakeram_dir      :=$(THIS_DIR)/bsg_fakeram
bsg_fakeram_url      :=$(GITHUB)bespoke-silicon-group/bsg_fakeram
bsg_fakeram_commit   :=master

bsg_cadenv_dir       :=$(THIS_DIR)/bsg_cadenv
bsg_cadenv_url       :=$(GITHUB)bespoke-silicon-group/bsg_cadenv
bsg_cadenv_commit    :=master

blackparrot_dir      :=$(THIS_DIR)/black-parrot
blackparrot_url      :=$(GITHUB)black-parrot/black-parrot
blackparrot_commit   :=tapeout_bp_rc5

all_repos = $(subst _url,.repo,$(filter %_url,$(.VARIABLES)))

all: $(all_repos)
	$(MAKE) -C $(bsg_fakeram_dir) tools

%.repo:
	-git clone $($*_url) $($*_dir)
	-cd $($*_dir) ; git checkout $($*_commit)

clean: are_you_sure
	rm -rf $(subst .repo,,$(all_repos))

DISABLE_SAFETY_PROMPT ?= false
are_you_sure:
	@$(DISABLE_SAFETY_PROMPT) || (echo -n "Are you sure [Y/n]? " && read ans && ([ "$$ans" == "Y" ] || [ "$$ans" == "y" ]))

