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
basejump_stl_commit  :=tapeout_bp_rc5

bsg_45_dir           :=$(THIS_DIR)/bsg_45
bsg_45_url           :=$(GITHUB)stdavids/bsg_45
bsg_45_commit        :=master

bsg_fakeram_dir      :=$(THIS_DIR)/bsg_fakeram
bsg_fakeram_url      :=$(GITHUB)bespoke-silicon-group/bsg_fakeram
bsg_fakeram_commit   :=master

bsg_cadenv_dir       :=$(THIS_DIR)/bsg_cadenv
bsg_cadenv_url       :=$(BITBUCKET)taylor-bsg/bsg_cadenv
bsg_cadenv_commit    :=master

board_dir            :=$(THIS_DIR)/board
board_url            :=$(BITBUCKET)taylor-bsg/board
board_commit         :=master

bsg_packaging_dir    :=$(THIS_DIR)/bsg_packaging
bsg_packaging_url    :=$(BITBUCKET)taylor-bsg/bsg_packaging
bsg_packaging_commit :=master

black_parrot_dir     :=$(THIS_DIR)/black-parrot
black_parrot_url     :=$(GITHUB)black-parrot/black-parrot
black_parrot_commit  :=tapeout_bp_rc5

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

